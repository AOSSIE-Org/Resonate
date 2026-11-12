import 'package:resonate/features/interests/model/interest.dart';

// The in-progress edit on the interests screen
class InterestsEditState {
  const InterestsEditState({this.selected, this.isSaving = false});

  final Set<Interest>? selected;
  final bool isSaving;

  bool get isLoaded => selected != null;

  bool get canSave => selected != null && !isSaving;

  bool get hasSelection => selected?.isNotEmpty ?? false;

  InterestsEditState copyWith({Set<Interest>? selected, bool? isSaving}) =>
      InterestsEditState(
        selected: selected ?? this.selected,
        isSaving: isSaving ?? this.isSaving,
      );
}
