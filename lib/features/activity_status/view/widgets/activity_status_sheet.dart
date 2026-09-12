import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/activity_status/data/my_activity_status.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

Future<void> showActivityStatusSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (_) => const ActivityStatusSheet(),
  );
}


class ActivityStatusSheet extends ConsumerWidget {
  const ActivityStatusSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final effective = ref.watch(myActivityStatusProvider);
    final isSystemDriven = !ActivityStatus.selectable.contains(effective);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              UiSizes.width_20,
              0,
              UiSizes.width_20,
              UiSizes.height_10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.activityStatus,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: UiSizes.size_18,
                  ),
                ),
                SizedBox(height: UiSizes.height_4),
                Text(
                  l10n.activityStatusSubtitle,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: UiSizes.size_13,
                  ),
                ),
              ],
            ),
          ),
          if (isSystemDriven) ...[
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20,
              ),
              leading: ActivityDot(status: effective, size: UiSizes.size_14),
              title: Text(effective.label(l10n)),
              subtitle: Text(effective.description(l10n)),
              enabled: false,
            ),
            Divider(height: UiSizes.height_16),
          ],
          for (final status in ActivityStatus.selectable)
            _StatusOption(
              status: status,
              isSelected: status == ref.read(myActivityStatusProvider.notifier).chosen,
              onTap: () => _select(context, ref, status),
            ),
          SizedBox(height: UiSizes.height_10),
        ],
      ),
    );
  }

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    ActivityStatus status,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    try {
      await ref.read(myActivityStatusProvider.notifier).setStatus(status);
      if (navigator.canPop()) navigator.pop();
    } catch (_) {
      if (navigator.canPop()) navigator.pop();
      customSnackbar(l10n.error, l10n.activityStatusUpdateFailed, LogType.error);
    }
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      leading: ActivityDot(status: status, size: UiSizes.size_14),
      title: Text(
        status.label(l10n),
        style: TextStyle(
          color: scheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        status.description(l10n),
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: UiSizes.size_12,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: scheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
