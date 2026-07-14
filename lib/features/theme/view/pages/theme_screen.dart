import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/theme/model/theme_enums.dart';
import 'package:resonate/features/theme/model/theme_list.dart';
import 'package:resonate/features/theme/model/theme_model.dart';
import 'package:resonate/features/theme/view/widgets/theme_tile_title.dart';
import 'package:resonate/features/theme/view/widgets/theme_tile_trailing.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ThemeList.themesList;
    final currentTheme = ref.watch(appThemeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.themes)),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_8,
          vertical: UiSizes.height_2,
        ),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final bool isSelected =
                currentTheme == Themes.fromName(list[index].name.toLowerCase());
            final String title = AppLocalizations.of(
              context,
            )!.chooseTheme("${list[index].name.toLowerCase()}Theme");

            final ThemeModel theme = list[index];
            final IconData iconData = ThemeIcons.values
                .firstWhere(
                  (e) => e.theme == theme.name.toLowerCase(),
                  orElse: () => ThemeIcons.classic,
                )
                .icon;
            return Container(
              margin: EdgeInsets.symmetric(vertical: UiSizes.height_5),
              decoration: BoxDecoration(),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_14,
                  horizontal: UiSizes.width_20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isSelected
                        ? theme.primaryColor
                        : Colors.transparent,
                    width: UiSizes.width_2, 
                  ),
                ),
                onTap: () {
                  ref
                      .read(appThemeProvider.notifier)
                      .setTheme(Themes.fromName(theme.name.toLowerCase()));
                },
                leading: Container(
                  padding: EdgeInsets.all(UiSizes.width_10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: UiSizes.width_1,
                    ),
                  ),
                  child: Icon(
                    iconData,
                    size: UiSizes.size_25,
                    color: Colors.white,
                  ),
                ),
                trailing: TileTrailing(
                  theme: theme,
                  isSelected: isSelected,
                ),
                tileColor: isSelected
                    ? theme.primaryColor
                    : Colors.black26,
                selected: isSelected,
                selectedColor: theme.primaryColor,
                selectedTileColor: theme.secondaryColor,
                title: TileTitle(
                  themeName: title,
                  theme: theme,
                  isSelected: isSelected,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
