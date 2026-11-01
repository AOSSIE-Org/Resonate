import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/shared/model/resonate_user.dart';

class InterestFilterState {
  const InterestFilterState({
    this.selected = const <Interest>{},
    this.matches = const AsyncValue<List<ResonateUser>>.data(<ResonateUser>[]),
  });

  final Set<Interest> selected;
  final AsyncValue<List<ResonateUser>> matches;

  bool get isActive => selected.isNotEmpty;

  InterestFilterState copyWith({
    Set<Interest>? selected,
    AsyncValue<List<ResonateUser>>? matches,
  }) => InterestFilterState(
    selected: selected ?? this.selected,
    matches: matches ?? this.matches,
  );
}
