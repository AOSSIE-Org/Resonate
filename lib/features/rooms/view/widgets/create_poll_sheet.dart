import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/rooms/data/room_polls.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

const int _minOptions = 2;
const int _maxOptions = 5;

Future<void> openCreatePollSheet(
  BuildContext context, {
  required String roomId,
  required String roomName,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CreatePollSheet(roomId: roomId, roomName: roomName),
  );
}

class CreatePollSheet extends ConsumerStatefulWidget {
  const CreatePollSheet({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  final String roomId;
  final String roomName;

  @override
  ConsumerState<CreatePollSheet> createState() => _CreatePollSheetState();
}

class _CreatePollSheetState extends ConsumerState<CreatePollSheet> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool _submitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length >= _maxOptions) return;
    setState(() => _optionControllers.add(TextEditingController()));
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= _minOptions) return;
    final controller = _optionControllers.removeAt(index);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final question = _questionController.text.trim();
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((option) => option.isNotEmpty)
        .toList();

    if (question.isEmpty) {
      customSnackbar(l10n.error, l10n.pollEnterQuestion, LogType.warning);
      return;
    }
    if (options.length < _minOptions) {
      customSnackbar(l10n.error, l10n.pollNeedTwoOptions, LogType.warning);
      return;
    }

    setState(() => _submitting = true);  
    final ok = await ref
        .read(roomPollsProvider(widget.roomId).notifier)
        .createPoll(
          question: question,
          options: options,
          roomName: widget.roomName,
        )
        .catchError((Object e) => false);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() => _submitting = false);
      customSnackbar(l10n.error, l10n.failedToCreatePoll, LogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Keep the polls provider alive while the sheet is open
    ref.watch(roomPollsProvider(widget.roomId));

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(UiSizes.width_16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.createPoll,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: UiSizes.height_15),
              TextField(
                controller: _questionController,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: l10n.pollQuestionLabel,
                  hintText: l10n.pollQuestionHint,
                  counterText: '',
                ),
              ),
              SizedBox(height: UiSizes.height_10),
              for (var i = 0; i < _optionControllers.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: UiSizes.height_8),
                  child: TextField(
                    controller: _optionControllers[i],
                    maxLength: 200,
                    decoration: InputDecoration(
                      hintText: l10n.pollOptionHint(i + 1),
                      counterText: '',
                      suffixIcon: _optionControllers.length > _minOptions
                          ? IconButton(
                              tooltip: l10n.removePollOption,
                              icon: const Icon(Icons.close),
                              onPressed: () => _removeOption(i),
                            )
                          : null,
                    ),
                  ),
                ),
              if (_optionControllers.length < _maxOptions)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addOption,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addPollOption),
                  ),
                ),
              SizedBox(height: UiSizes.height_15),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? SizedBox(
                        height: UiSizes.size_20,
                        width: UiSizes.size_20,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.createPoll),
              ),
              SizedBox(height: UiSizes.height_10),
            ],
          ),
        ),
      ),
    );
  }
}
