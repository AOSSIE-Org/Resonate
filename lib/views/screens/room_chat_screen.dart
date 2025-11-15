import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/room_chat_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';

import 'package:resonate/models/message.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class RoomChatScreen extends StatefulWidget {
  const RoomChatScreen({super.key});

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final RoomChatController chatController = Get.find<RoomChatController>();
  AuthStateController auth = Get.find<AuthStateController>();
  final double itemHight = 80;
  late Future<void> loadMessagesFuture;

  void scrollToMessage(int index) {
    _scrollController.animateTo(
      index * itemHight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollToBottom() {
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

  Future<void> updateMessage(int index, String newContent) async {
    await chatController.editMessage(
      chatController.messages[index].messageId,
      newContent,
    );
  }

  @override
  void initState() {
    super.initState();

    loadMessagesFuture = chatController.loadMessages();

    // Listen to changes in messages and scroll to bottom when new messages are added
    ever(chatController.messages, (messages) {
      if (messages.isNotEmpty) {
        scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    Get.delete<RoomChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Room Chat'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: loadMessagesFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                } else {
                  // Scroll to bottom after messages are loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });

                  return Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: chatController.messages.length,
                      itemBuilder: (context, index) {
                        return ChatMessageItem(
                          message: chatController.messages[index],
                          onTapReply: (int replyIndex) =>
                              scrollToMessage(replyIndex),
                          onEditMessage: (String newContent) async {
                            await updateMessage(index, newContent);
                          },
                          onDeleteMessage: (String messageId) async {
                            try {
                              await chatController.deleteMessage(messageId);
                              customSnackbar(
                                AppLocalizations.of(context)!.success,
                                AppLocalizations.of(context)!.delete,
                                LogType.success,
                              );
                            } catch (e) {
                              customSnackbar(
                                AppLocalizations.of(context)!.error,
                                AppLocalizations.of(
                                  context,
                                )!.failedToDeleteMessage,
                                LogType.error,
                              );
                            }
                          },
                          replytoMessage: (Message message) =>
                              chatController.setReplyingTo(message),
                          canEdit:
                              auth.appwriteUser.$id ==
                                  chatController.messages[index].creatorId &&
                              !chatController.messages[index].isDeleted &&
                              !chatController.messages[index].isEdited,

                          canDelete:
                              auth.appwriteUser.$id ==
                                  chatController.messages[index].creatorId &&
                              !chatController.messages[index].isDeleted,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}

class ChatMessageItem extends StatefulWidget {
  final Message message;
  final void Function(int) onTapReply;
  final void Function(String) onEditMessage;
  final void Function(Message) replytoMessage;
  final void Function(String) onDeleteMessage;
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
  });

  @override
  ChatMessageItemState createState() => ChatMessageItemState();
}

class ChatMessageItemState extends State<ChatMessageItem> {
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

  void startEditing() {
    if (widget.message.isDeleted) {
      return;
    }
    setState(() {
      isEditing = true;
    });
    _editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _editingController.text.length),
    );
  }

  void saveEdit() {
    widget.onEditMessage(_editingController.text);
    setState(() {
      isEditing = false;
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
    });
    _editingController.text = widget.message.content;
  }

  void _showMessageContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Wrap(
            children: [
              if (widget.canDelete)
                ///delete option
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(AppLocalizations.of(context)!.delete),

                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context);
                  },
                ),

              ///cancel option
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(AppLocalizations.of(context)!.cancel),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMessageTitle),
        content: Text(AppLocalizations.of(context)!.deleteMessageContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDeleteMessage(widget.message.messageId);
            },
            child: Text(AppLocalizations.of(context)!.delete),
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
                  _dragOffset = 0.0; // Reset if dragging left
                }
                setState(() {});
              },
              onHorizontalDragEnd: (details) {
                if (_dragOffset > 70) {
                  // Detected swipe from left to right
                  widget.replytoMessage(widget.message);
                }
                setState(() {
                  _dragOffset = 0.0; // Reset offset after swipe
                });
              },
              onDoubleTap: widget.canEdit ? startEditing : null,
              child: Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),

                    decoration: BoxDecoration(
                      color: widget.message.isDeleted
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                widget.message.creatorImgUrl,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.message.creatorName.capitalizeFirst!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.message.isDeleted
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant
                                          : Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  if (widget.message.replyTo != null)
                                    GestureDetector(
                                      onTap: () => widget.onTapReply(
                                        widget.message.replyTo!.index,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "@${widget.message.replyTo!.creatorUsername}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              widget.message.replyTo!.content,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (isEditing)
                                    ///the message to edit it AND the message is not deleted
                                    Focus(
                                      onKeyEvent: (node, event) {
                                        if (event.logicalKey ==
                                            LogicalKeyboardKey.escape) {
                                          cancelEdit();
                                          return KeyEventResult.handled;
                                        }
                                        return KeyEventResult.ignored;
                                      },
                                      child: TextField(
                                        controller: _editingController,
                                        autofocus: true,
                                        onSubmitted: (value) => saveEdit(),
                                        onTapOutside: (event) => cancelEdit(),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                        ),
                                      ),
                                    )
                                  else if (widget.message.isDeleted)
                                    ///The message has been deleted (`isDeleted = true`)
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
                                          const Text(
                                            ' (edited)',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),

                                  const SizedBox(height: 5),
                                  Text(
                                    widget.message.creationDateTime
                                        .formatDateTime(context)
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: (constraints.minHeight) / 2,
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

class ChatInputField extends StatelessWidget {
  ChatInputField({super.key});

  final RoomChatController chatController = Get.find<RoomChatController>();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (chatController.replyingTo.value != null)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 5),
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
                                "@${chatController.replyingTo.value?.creatorUsername ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                chatController.replyingTo.value?.content ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          chatController.clearReplyingTo();
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onSubmitted: (value) async {
                          if (_messageController.text.isNotEmpty) {
                            await chatController.sendMessage(
                              _messageController.text,
                            );
                            _messageController.clear();
                            // Clear reply if user sends a message
                            chatController.clearReplyingTo();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Say Something',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_messageController.text.isNotEmpty) {
                          await chatController.sendMessage(
                            _messageController.text,
                          );
                          _messageController.clear();
                          // Clear reply if user sends a message
                          chatController.clearReplyingTo();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
