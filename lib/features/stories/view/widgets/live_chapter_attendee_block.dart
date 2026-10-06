import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/profile/view/widgets/user_profile_card.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/session_participant_card.dart';

class LiveChapterAttendeeBlock extends ConsumerWidget {
  const LiveChapterAttendeeBlock({
    super.key,
    required this.user,
    this.featured = false,
    this.isMicOn,
  });

  final LiveChapterAttendee user;

  final bool featured;
  final bool? isMicOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAuthor =
        ref.watch(liveChapterProvider).model?.authorUid == user.id;
    final name = user.name ?? '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => showUserProfileCard(
        context,
        uid: user.id,
        name: name,
        avatarUrl: resolveAvatarUrl(ref, user.profileImageUrl),
      ),
      child: SessionParticipantCard(
        uid: user.id,
        name: name,
        role: isAuthor ? l10n.author : l10n.listener,
        avatarUrl: user.profileImageUrl,
        featured: featured,
        isMicOn: isMicOn,
      ),
    );
  }
}
