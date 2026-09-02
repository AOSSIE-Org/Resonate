import 'package:flutter/material.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';


class MessageStatusIndicator extends StatelessWidget {
  const MessageStatusIndicator({
    super.key,
    required this.status,
    required this.onRetry,
  });

  final RoomMessageStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case RoomMessageStatus.sent:
        return const SizedBox.shrink();
      case RoomMessageStatus.pending:
        return Icon(
          Icons.access_time,
          size: UiSizes.size_12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case RoomMessageStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: Tooltip(
            message: AppLocalizations.of(context)!.tapToRetry,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: UiSizes.size_14,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(width: UiSizes.width_4),
                Text(
                  AppLocalizations.of(context)!.retry,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: UiSizes.size_12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
