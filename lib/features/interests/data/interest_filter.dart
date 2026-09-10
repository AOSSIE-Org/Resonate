import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/model/interest_filter_state.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/interest_filter.g.dart';

@riverpod
class InterestFilter extends _$InterestFilter {
  int _generation = 0;

  @override
  InterestFilterState build() => const InterestFilterState();

  Future<void> toggle(Interest interest) {
    final selected = {...state.selected};
    if (!selected.remove(interest)) selected.add(interest);
    return _apply(selected);
  }

  Future<void> clear() => _apply(const <Interest>{});

  Future<void> refresh() => _apply(state.selected);

  Future<void> _apply(Set<Interest> selected) async {
    final generation = ++_generation;
    state = state.copyWith(
      selected: selected,
      matches: selected.isEmpty
          ? const AsyncValue.data(<ResonateUser>[])
          : const AsyncValue.loading(),
    );
    if (selected.isEmpty) return;

    final matches = await AsyncValue.guard(
      () => ref
          .read(interestsRepositoryProvider)
          .usersWithInterests(
            selected,
            excludeUid: ref.read(currentUserProvider)?.uid,
          ),
    );
    if (!ref.mounted || generation != _generation) return;
    state = state.copyWith(matches: matches);
  }
}
