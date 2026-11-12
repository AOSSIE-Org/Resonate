import 'package:flutter/material.dart';
import 'package:resonate/features/miniplayer/model/miniplayer_session.dart';
import 'package:resonate/shared/widgets/speaking_profile_avatar.dart';
import 'package:resonate/utils/ui_sizes.dart';


class SessionMiniplayer extends StatelessWidget {
  const SessionMiniplayer({
    super.key,
    required this.session,
    required VoidCallback this.onRestore,
    required VoidCallback this.onToggleMic,
    required VoidCallback this.onLeave,
  }) : pip = false;

  // A picture-in-picture window never receives touches
  const SessionMiniplayer.pip({super.key, required this.session})
    : pip = true,
      onRestore = null,
      onToggleMic = null,
      onLeave = null;

  final MiniplayerSession session;

  final VoidCallback? onRestore;
  final VoidCallback? onToggleMic;
  final VoidCallback? onLeave;

  final bool pip;

  @override
  Widget build(BuildContext context) {
    return pip ? _pipStage(context) : _bar(context);
  }

  Widget _pipStage(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = session.title;
    return Material(
      color: scheme.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final side = constraints.biggest.shortestSide;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: side * 0.08),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: side * 0.09,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: side * 0.07),
                ],
                SpeakingProfileAvatar(
                  uid: session.speakerUid,
                  imageUrl: session.avatarUrl,
                  radius: side * 0.24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = session.title;

    return Material(
      color: scheme.secondary,
      borderRadius: BorderRadius.circular(UiSizes.width_56),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      child: InkWell(
        onTap: onRestore,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_10,
            vertical: UiSizes.height_8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpeakingProfileAvatar(
                uid: session.speakerUid,
                imageUrl: session.avatarUrl,
                radius: UiSizes.size_20,
              ),
              if (title != null) ...[
                SizedBox(width: UiSizes.width_10),
                // Bounded so a long room name cannot push the controls out.
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: UiSizes.width_140),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: UiSizes.size_16,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
              SizedBox(width: UiSizes.width_8),
              _MiniAction(
                id: 'mic',
                icon: session.isMicOn ? Icons.mic : Icons.mic_off,
                background: session.isMicOn
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                foreground: session.isMicOn
                    ? scheme.onPrimary
                    : scheme.onSurface,
                // A listener has no mic to turn on; the icon stays dimmed.
                onTap: session.canToggleMic ? onToggleMic : null,
              ),
              _MiniAction(
                id: 'leave',
                icon: Icons.call_end,
                background: scheme.error,
                foreground: scheme.onError,
                onTap: onLeave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.id,
    required this.icon,
    required this.background,
    required this.foreground,
    this.onTap,
  });

  final String id;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_4),
      child: Material(
        key: ValueKey('miniplayer-$id'),
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: UiSizes.width_40,
            height: UiSizes.width_40,
            child: Center(
              child: Icon(
                icon,
                size: UiSizes.size_20,
                color: onTap == null
                    ? foreground.withValues(alpha: 0.4)
                    : foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
