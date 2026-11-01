import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/shared/widgets/app_loader.dart';
import 'package:resonate/features/stories/view/widgets/recorded_chapter_tile.dart';
import 'package:resonate/features/stories/viewmodel/recorded_chapters_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RecordedChaptersPage extends ConsumerWidget {
  const RecordedChaptersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final chaptersAsync = ref.watch(recordedChaptersProvider);
    final refresh = ref.read(recordedChaptersProvider.notifier).refresh;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(l10n.recordedChapters)),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: chaptersAsync.when(
          loading: () => _scrollable(const AppLoader()),
          error: (_, _) => _scrollable(_ErrorView(onRetry: refresh)),
          data: (chapters) => chapters.isEmpty
              ? _scrollable(const _EmptyView())
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return RecordedChapterTile(
                      chapter: chapter,
                      onTap: () => context.push(
                        RoutePaths.recordedChapterDetail,
                        extra: chapter,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _scrollable(Widget child) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_30,
        vertical: UiSizes.height_80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.emptyBoxImage,
            height: UiSizes.height_200,
            width: UiSizes.width_200,
          ),
          SizedBox(height: UiSizes.height_20),
          Text(
            l10n.noRecordedChapters,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiSizes.size_20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: UiSizes.height_10),
          Text(
            l10n.noRecordedChaptersMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_30,
        vertical: UiSizes.height_80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: UiSizes.size_56,
            color: colorScheme.error,
          ),
          SizedBox(height: UiSizes.height_20),
          Text(
            l10n.recordedChaptersLoadFailed,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: UiSizes.size_18),
          ),
          SizedBox(height: UiSizes.height_20),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
