import 'package:flutter/material.dart';
import 'package:resonate/features/stories/model/story_tags.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class TagInput extends StatefulWidget {
  const TagInput({
    required this.tags,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<String> tags;
  final bool Function(String tag) onAdd;
  final ValueChanged<String> onRemove;

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final tag = normalizeStoryTag(_controller.text);
    if (tag.isEmpty) return;
    if (widget.onAdd(tag)) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          maxLength: kMaxStoryTagLength,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: l10n.addTag,
            labelStyle: TextStyle(color: scheme.onSurfaceVariant),
            counterText: '',
            enabledBorder: _border(scheme.inversePrimary),
            focusedBorder: _border(scheme.primary),
            suffixIcon: IconButton(
              onPressed: _submit,
              icon: const Icon(Icons.add),
              tooltip: l10n.addTag,
            ),
          ),
        ),
        if (widget.tags.isNotEmpty) ...[
          SizedBox(height: UiSizes.height_10),
          Wrap(
            spacing: UiSizes.width_8,
            runSpacing: UiSizes.height_8,
            children: [
              for (final tag in widget.tags)
                InputChip(
                  label: Text(tag),
                  onDeleted: () => widget.onRemove(tag),
                  deleteButtonTooltipMessage: l10n.removeTag(tag),
                  backgroundColor: scheme.secondary,
                ),
            ],
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: color),
  );
}
