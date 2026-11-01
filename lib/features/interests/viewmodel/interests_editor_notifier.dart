import 'package:resonate/features/interests/data/my_interests.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/model/interests_edit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/interests_editor_notifier.g.dart';

@riverpod
class InterestsEditor extends _$InterestsEditor {
  bool _seeded = false;

  @override
  InterestsEditState build() {
    ref.listen(myInterestsProvider, (_, next) {
      if (_seeded) return;
      if (next case AsyncData(:final value)) {
        _seeded = true;
        state = state.copyWith(selected: value.toSet());
      }
    });

    final stored = ref.read(myInterestsProvider).value;
    if (stored == null) return const InterestsEditState();
    _seeded = true;
    return InterestsEditState(selected: stored.toSet());
  }

  // False when the cap turned the selection down, so the screen can say so.
  bool toggle(Interest interest) {
    final selected = state.selected;
    if (selected == null) return true;

    final next = {...selected};
    if (next.remove(interest)) {
      state = state.copyWith(selected: next);
      return true;
    }
    if (next.length >= Interest.maxSelectable) return false;

    next.add(interest);
    state = state.copyWith(selected: next);
    return true;
  }

  void clear() {
    if (state.selected == null) return;
    state = state.copyWith(selected: const <Interest>{});
  }

  Future<bool> save() async {
    final selected = state.selected;
    if (selected == null || state.isSaving) return false;

    state = state.copyWith(isSaving: true);
    final saved = await ref
        .read(myInterestsProvider.notifier)
        .save(selected.toList());
    if (ref.mounted) state = state.copyWith(isSaving: false);
    return saved;
  }
}
