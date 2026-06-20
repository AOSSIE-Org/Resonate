import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LiveChapterAttendeeBlock extends ConsumerWidget {
  const LiveChapterAttendeeBlock({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final model = ref.watch(liveChapterProvider).model;
    final isAuthorBlock = model?.authorUid == user['\$id'];
    final viewerIsAdmin = model?.authorUid == currentAuthUser?.uid;

    return FocusedMenuHolder(
      onPressed: () {},
      menuItemExtent: UiSizes.width_45,
      menuWidth: UiSizes.width_200 * 1.05,
      menuBoxDecoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(UiSizes.width_5),
        border: Border.all(color: colorScheme.primary, width: UiSizes.width_1),
      ),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: brightness == Brightness.light
          ? Colors.white54
          : Colors.black54,
      menuItems: const <FocusedMenuItem>[],
      openWithTap: viewerIsAdmin,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_2,
          horizontal: UiSizes.width_2,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              radius: UiSizes.size_32,
              backgroundColor: colorScheme.primary,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
                radius: UiSizes.size_30,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (user["name"] ?? '').toString().split(' ').first,
                    style: TextStyle(fontSize: UiSizes.size_16),
                  ),
                ],
              ),
            ),
            Text(
              isAuthorBlock
                  ? AppLocalizations.of(context)!.author
                  : AppLocalizations.of(context)!.listener,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: UiSizes.size_14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
