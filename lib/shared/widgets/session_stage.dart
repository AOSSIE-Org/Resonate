import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

// The body of a live session screen
class SessionStage extends StatelessWidget {
  const SessionStage({
    super.key,
    required this.featured,
    required this.tiles,
    required this.controls,
    this.emptyState,
  });

  final List<Widget> featured;

  final List<Widget> tiles;

  final Widget? emptyState;

  final Widget controls;

  static EdgeInsets get sectionPadding => EdgeInsets.fromLTRB(
    UiSizes.width_16,
    0,
    UiSizes.width_16,
    UiSizes.height_10,
  );

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 3.0);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            for (final card in featured)
              SliverPadding(
                padding: sectionPadding,
                sliver: SliverToBoxAdapter(child: card),
              ),
            if (tiles.isEmpty)
              if (emptyState != null)
                SliverFillRemaining(hasScrollBody: false, child: emptyState!)
              else
                const SliverToBoxAdapter(child: SizedBox.shrink())
            else
              SliverPadding(
                padding: sectionPadding,
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: UiSizes.width_8,
                    mainAxisSpacing: UiSizes.height_8,
                    childAspectRatio: 0.79 / textScale,
                  ),
                  itemCount: tiles.length,
                  itemBuilder: (_, index) => tiles[index],
                ),
              ),
            // Clearance so the last row is not trapped under the controls.
            SliverToBoxAdapter(child: SizedBox(height: UiSizes.height_131)),
          ],
        ),
        controls,
      ],
    );
  }
}

// The "nobody is here yet" message both stages use.
class SessionStageEmpty extends StatelessWidget {
  const SessionStageEmpty({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: UiSizes.size_65,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: UiSizes.height_16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiSizes.size_16,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
