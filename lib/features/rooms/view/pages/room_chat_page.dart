import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class RoomChatPage extends ConsumerStatefulWidget {
  const RoomChatPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.isUpcoming,
  });

  final String roomId;
  final String roomName;
  final bool isUpcoming;

  @override
  ConsumerState<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends ConsumerState<RoomChatPage> {
  final ScrollController _scrollController = ScrollController();
  static const double _itemHeight = 80;
  int _previousCount = 0;

  void _scrollToMessage(int index) {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      index * _itemHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerKey = roomChatProvider(
      widget.roomId,
      widget.roomName,
      widget.isUpcoming,
    );
    final asyncState = ref.watch(providerKey);
    final messages = asyncState.value?.messages ?? const <RoomMessage>[];
    if (messages.length != _previousCount) {
      _previousCount = messages.length;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.roomChat),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: asyncState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(AppLocalizations.of(context)!.error)),
              data: (state) => ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(UiSizes.width_16),
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
                  final canEdit = ref.read(requireUserProvider).uid == message.creatorId &&
                      !message.isDeleted &&
                      !message.isEdited;
                  final canDelete = ref.read(requireUserProvider).uid == message.creatorId &&
                      !message.isDeleted;
                  return ChatMessageItem(
                    message: message,
                    onTapReply: _scrollToMessage,
                    onEditMessage: (newContent) async {
                      await ref
                          .read(providerKey.notifier)
                          .editMessage(
                            messageId: message.messageId,
                            roomName: widget.roomName,
                            isUpcoming: widget.isUpcoming,
                            newContent: newContent,
                          );
                    },
                    onDeleteMessage: (id) async {
                      try {
                        await ref.read(providerKey.notifier).deleteMessage(id);
                        if (!context.mounted) return;
                        customSnackbar(
                          AppLocalizations.of(context)!.success,
                          AppLocalizations.of(context)!.delete,
                          LogType.success,
                        );
                      } catch (_) {
                        if (!context.mounted) return;
                        customSnackbar(
                          AppLocalizations.of(context)!.error,
                          AppLocalizations.of(
                            context,
                          )!.failedToDeleteMessage,
                          LogType.error,
                        );
                      }
                    },
                    replytoMessage: (m) =>
                        ref.read(providerKey.notifier).setReplyingTo(m),
                    onRetry: () async {
                      final ok = await ref.read(providerKey.notifier).retrySend(
                        messageId: message.messageId,
                        roomName: widget.roomName,
                        isUpcoming: widget.isUpcoming,
                      );
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.failedToResend,
                            ),
                          ),
                        );
                      }
                    },
                    canEdit: canEdit,
                    canDelete: canDelete,
                  );
                },
              ),
            ),
          ),
          ChatInputField(
            roomId: widget.roomId,
            roomName: widget.roomName,
            isUpcoming: widget.isUpcoming,
          ),
        ],
      ),
    );
  }
}

class ChatMessageItem extends StatefulWidget {
  final RoomMessage message;
  final void Function(int) onTapReply;
  final void Function(String) onEditMessage;
  final void Function(RoomMessage) replytoMessage;
  final void Function(String) onDeleteMessage;
  final VoidCallback? onRetry;
  final bool canDelete;
  final bool canEdit;

  const ChatMessageItem({
    super.key,
    required this.message,
    required this.onTapReply,
    required this.onEditMessage,
    required this.replytoMessage,
    required this.canEdit,
    required this.onDeleteMessage,
    required this.canDelete,
    this.onRetry,
  });

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  bool isEditing = false;
  late TextEditingController _editingController;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.message.content);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (widget.message.isDeleted) return;
    setState(() => isEditing = true);
    _editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _editingController.text.length),
    );
  }

  void _saveEdit() {
    widget.onEditMessage(_editingController.text);
    setState(() => isEditing = false);
  }

  void _cancelEdit() {
    setState(() => isEditing = false);
    _editingController.text = widget.message.content;
  }

  void _showMessageContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            if (widget.canDelete)
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(ctx).colorScheme.error,
                ),
                title: Text(AppLocalizations.of(ctx)!.delete),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(AppLocalizations.of(ctx)!.cancel),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.deleteMessageTitle),
        content: Text(AppLocalizations.of(ctx)!.deleteMessageContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDeleteMessage(widget.message.messageId);
            },
            child: Text(AppLocalizations.of(ctx)!.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            GestureDetector(
              onLongPress: () => _showMessageContextMenu(context),
              onHorizontalDragUpdate: (details) {
                if (_dragOffset + details.delta.dx > 0.0 &&
                    _dragOffset + details.delta.dx < 100) {
                  _dragOffset += details.delta.dx;
                } else if (_dragOffset + details.delta.dx > 100) {
                  _dragOffset = 100;
                } else if (_dragOffset + details.delta.dx < 0) {
                  _dragOffset = 0.0;
                }
                setState(() {});
              },
              onHorizontalDragEnd: (_) {
                if (_dragOffset > 70) {
                  widget.replytoMessage(widget.message);
                }
                setState(() => _dragOffset = 0.0);
              },
              onDoubleTap: widget.canEdit ? _startEditing : null,
              child: Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: UiSizes.height_2),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(UiSizes.width_8),
                    decoration: BoxDecoration(
                      color: widget.message.isDeleted
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: UiSizes.size_20,
                          backgroundImage: NetworkImage(
                            widget.message.creatorImgUrl,
                          ),
                        ),
                        SizedBox(width: UiSizes.width_10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _capitalize(widget.message.creatorName),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.message.isDeleted
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              SizedBox(height: UiSizes.height_5),
                              if (widget.message.replyTo != null)
                                GestureDetector(
                                  onTap: () => widget.onTapReply(
                                    widget.message.replyTo!.index,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(UiSizes.width_8),
                                    margin: EdgeInsets.only(bottom: UiSizes.height_5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@${widget.message.replyTo!.creatorUsername}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          widget.message.replyTo!.content,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (isEditing)
                                Focus(
                                  onKeyEvent: (node, event) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.escape) {
                                      _cancelEdit();
                                      return KeyEventResult.handled;
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                  child: TextField(
                                    controller: _editingController,
                                    autofocus: true,
                                    onSubmitted: (_) => _saveEdit(),
                                    onTapOutside: (_) => _cancelEdit(),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(
                                            horizontal: UiSizes.width_10,
                                            vertical: UiSizes.height_5,
                                          ),
                                    ),
                                  ),
                                )
                              else if (widget.message.isDeleted)
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.thisMessageWasDeleted,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.message.content,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                    if (widget.message.isEdited)
                                      Text(
                                        AppLocalizations.of(context)!.edited,
                                        style: TextStyle(
                                          fontSize: UiSizes.size_12,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              SizedBox(height: UiSizes.height_5),
                              Row(
                                children: [
                                  Text(
                                    widget.message.creationDateTime
                                        .formatDateTime(context)
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: UiSizes.size_12,
                                    ),
                                  ),
                                  SizedBox(width: UiSizes.width_6),
                                  _StatusIndicator(
                                    status: widget.message.status,
                                    onRetry: widget.onRetry,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: constraints.minHeight / 2,
              top: constraints.minHeight / 2,
              child: Transform.translate(
                offset: Offset(_dragOffset - 70, 0),
                child: Opacity(
                  opacity: (_dragOffset / 100).clamp(0.0, 1.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.reply,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChatInputField extends ConsumerStatefulWidget {
  const ChatInputField({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.isUpcoming,
  });

  final String roomId;
  final String roomName;
  final bool isUpcoming;

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_messageController.text.isEmpty) return;
    final content = _messageController.text;
    _messageController.clear();
    final providerKey =
        roomChatProvider(widget.roomId, widget.roomName, widget.isUpcoming);
    final ok = await ref.read(providerKey.notifier).sendMessage(
      roomId: widget.roomId,
      roomName: widget.roomName,
      isUpcoming: widget.isUpcoming,
      content: content,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToSendTapRetry),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerKey =
        roomChatProvider(widget.roomId, widget.roomName, widget.isUpcoming);
    final replyingTo = ref.watch(providerKey).value?.replyingTo;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(UiSizes.width_16),
          child: Column(
            children: [
              if (replyingTo != null)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(UiSizes.width_8),
                        margin: EdgeInsets.only(bottom: UiSizes.height_5),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${replyingTo.creatorUsername}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              replyingTo.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          ref.read(providerKey.notifier).clearReplyingTo(),
                    ),
                  ],
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.saySomething,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: UiSizes.width_20,
                          vertical: UiSizes.height_5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: UiSizes.width_10),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

Future<void> openLiveRoomChatSheet(BuildContext context, AppwriteRoom room) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => RoomChatPage(
      roomId: room.id,
      roomName: room.name,
      isUpcoming: false,
    ),
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    ),
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
  );
}

Future<void> openUpcomingChatSheet(
  BuildContext context,
  AppwriteUpcomingRoom room,
) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => RoomChatPage(
      roomId: room.id,
      roomName: room.name,
      isUpcoming: true,
    ),
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    ),
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
  );
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.status, required this.onRetry});

  final RoomMessageStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case RoomMessageStatus.sent:
        return const SizedBox.shrink();
      case RoomMessageStatus.pending:
        return Icon(Icons.access_time, size: UiSizes.size_12, color: Colors.grey);
      case RoomMessageStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: Tooltip(
            message: AppLocalizations.of(context)!.tapToRetry,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: UiSizes.size_14, color: Colors.red),
                SizedBox(width: UiSizes.width_4),
                Text(
                  AppLocalizations.of(context)!.retry,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: UiSizes.size_12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
