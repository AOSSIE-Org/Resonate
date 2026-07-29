import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/model/room_polls_state.dart';
import 'package:resonate/features/rooms/model/voter_profile.dart';
import 'package:resonate/features/rooms/view/widgets/message_status_indicator.dart';
import 'package:resonate/features/rooms/data/room_polls.dart';
import 'package:resonate/features/rooms/data/voter_profiles.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/utils/ui_sizes.dart';


class PollCard extends ConsumerWidget {
  const PollCard({
    super.key,
    required this.message,
    required this.isUserAdmin,
    this.onRetry,
  });

  final RoomMessage message;
  final bool isUserAdmin;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollId = message.pollId!;
    final pollsKey = roomPollsProvider(message.roomId);
    final asyncPolls = ref.watch(pollsKey);
    final pollsState = asyncPolls.value;
    final poll = pollsState?.pollById(pollId);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_2),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(UiSizes.width_8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: UiSizes.size_20,
              backgroundImage: NetworkImage(message.creatorImgUrl),
            ),
            SizedBox(width: UiSizes.width_10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalize(message.creatorName),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: UiSizes.height_5),
                  Row(
                    children: [
                      Icon(
                        Icons.poll_outlined,
                        size: UiSizes.size_14,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: UiSizes.width_4),
                      Text(
                        AppLocalizations.of(context)!.poll,
                        style: TextStyle(
                          fontSize: UiSizes.size_12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UiSizes.height_5),
                  if (pollsState == null && asyncPolls.isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: UiSizes.height_8,
                      ),
                      child: SizedBox(
                        height: UiSizes.size_20,
                        width: UiSizes.size_20,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (pollsState == null && asyncPolls.hasError)
                    Text(
                      AppLocalizations.of(context)!.error,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else if (poll == null)
                    Text(
                      AppLocalizations.of(context)!.pollUnavailable,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    _PollBody(
                      poll: poll,
                      pollsState: pollsState!,
                      isUserAdmin: isUserAdmin,
                    ),
                  SizedBox(height: UiSizes.height_5),
                  Row(
                    children: [
                      Text(
                        message.creationDateTime
                            .formatDateTime(context)
                            .toString(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withValues(alpha: 0.7),
                          fontSize: UiSizes.size_12,
                        ),
                      ),
                      SizedBox(width: UiSizes.width_6),
                      MessageStatusIndicator(
                        status: message.status,
                        onRetry: onRetry,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PollBody extends ConsumerWidget {
  const _PollBody({
    required this.poll,
    required this.pollsState,
    required this.isUserAdmin,
  });

  final Poll poll;
  final RoomPollsState pollsState;
  final bool isUserAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = pollsState.optionCountsFor(poll);
    final totalVotes = counts.fold(0, (sum, count) => sum + count);
    final myVote = pollsState.voteByUser(
      poll.pollId,
      ref.watch(requireUserProvider).uid,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          poll.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: UiSizes.size_14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: UiSizes.height_5),
        for (var i = 0; i < poll.options.length; i++)
          _PollOption(
            poll: poll,
            optionIndex: i,
            count: counts[i],
            totalVotes: totalVotes,
            isMyVote: myVote?.optionIndex == i,
            voterUids: [
              for (final v in pollsState.votes)
                if (v.pollId == poll.pollId && v.optionIndex == i) v.uid,
            ],
          ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.pollVotesCount(totalVotes),
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.7),
                fontSize: UiSizes.size_12,
              ),
            ),
            const Spacer(),
            if (poll.isClosed)
              Text(
                AppLocalizations.of(context)!.pollFinalResults,
                style: TextStyle(
                  fontSize: UiSizes.size_12,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              )
            else if (isUserAdmin)
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => _confirmEndPoll(context, ref),
                child: Text(
                  AppLocalizations.of(context)!.endPoll,
                  style: TextStyle(fontSize: UiSizes.size_12),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _confirmEndPoll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.endPollConfirmTitle),
        content: Text(AppLocalizations.of(ctx)!.endPollConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await ref
                  .read(roomPollsProvider(poll.roomId).notifier)
                  .closePoll(poll.pollId);
              if (!ok && context.mounted) {
                customSnackbar(
                  AppLocalizations.of(context)!.error,
                  AppLocalizations.of(context)!.failedToEndPoll,
                  LogType.error,
                );
              }
            },
            child: Text(AppLocalizations.of(ctx)!.endPoll),
          ),
        ],
      ),
    );
  }
}

class _PollOption extends ConsumerWidget {
  const _PollOption({
    required this.poll,
    required this.optionIndex,
    required this.count,
    required this.totalVotes,
    required this.isMyVote,
    required this.voterUids,
  });

  final Poll poll;
  final int optionIndex;
  final int count;
  final int totalVotes;
  final bool isMyVote;
  final List<String> voterUids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final share = totalVotes == 0 ? 0.0 : count / totalVotes;

    return Padding(
      padding: EdgeInsets.only(bottom: UiSizes.height_5),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: poll.isClosed
            ? null
            : () async {
                final ok = await ref
                    .read(roomPollsProvider(poll.roomId).notifier)
                    .vote(pollId: poll.pollId, optionIndex: optionIndex);
                if (!ok && context.mounted) {
                  customSnackbar(
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.failedToVote,
                    LogType.error,
                  );
                }
              },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isMyVote ? colorScheme.primary : Colors.transparent,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: share),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) => FractionallySizedBox(
                      widthFactor: value.clamp(0.0, 1.0),
                      heightFactor: 1,
                      child: ColoredBox(
                        color: colorScheme.onSecondaryContainer.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(UiSizes.width_8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            poll.options[optionIndex],
                            style: TextStyle(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: isMyVote
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isMyVote) ...[
                          Icon(
                            Icons.check_circle,
                            size: UiSizes.size_14,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: UiSizes.width_4),
                        ],
                        if (totalVotes > 0)
                          Text(
                            '${(share * 100).round()}%',
                            style: TextStyle(
                              fontSize: UiSizes.size_12,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                      ],
                    ),
                    if (voterUids.isNotEmpty) ...[
                      SizedBox(height: UiSizes.height_5),
                      _VoterAvatars(
                        roomId: poll.roomId,
                        voterUids: voterUids,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoterAvatars extends ConsumerWidget {
  const _VoterAvatars({required this.roomId, required this.voterUids});

  final String roomId;
  final List<String> voterUids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final profiles = ref.watch(voterProfilesProvider(roomId));

    final shown = voterUids.take(kPollOptionAvatarCap).toList();
    final overflow = voterUids.length - shown.length;
    final avatarSize = UiSizes.size_20;
    // Overlap each avatar over the previous one.
    final step = avatarSize * 0.65;

    return SizedBox(
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * step,
              child: _avatar(colorScheme, profiles[shown[i]], avatarSize),
            ),
          if (overflow > 0)
            Positioned(
              left: shown.length * step,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                  border: Border.all(color: colorScheme.secondaryContainer),
                ),
                child: Text(
                  '+$overflow',
                  style: TextStyle(
                    fontSize: UiSizes.size_12,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _avatar(ColorScheme colorScheme, VoterProfile? profile, double size) {
    final url = profile?.avatarUrl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.secondaryContainer, width: 1.5),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: colorScheme.primary,
        backgroundImage: (url != null && url.isNotEmpty)
            ? NetworkImage(url)
            : null,
      ),
    );
  }
}

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
