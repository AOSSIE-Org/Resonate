import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/models/themes_model.dart';
import 'package:resonate/themes/theme_icon_enum.dart';
import 'package:resonate/themes/theme_list.dart';
import 'package:resonate/themes/theme_tile_title.dart';
import 'package:resonate/themes/theme_tile_trailing.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  final List<ThemeModel> list = ThemeList.themesList;
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Themes")),
      body: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: (themeController.currentTheme.value == 'none')
              ? const Text("none")
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        themeController.currentTheme.value ==
                        list[index].name.toLowerCase();

                    final String title = AppLocalizations.of(
                      context,
                    )!.chooseTheme("${list[index].name.toLowerCase()}Theme");

                    final ThemeModel theme = list[index];

                    // [IconData] themes accordingly
                    final IconData iconData = ThemeIcons.values
                        .firstWhere(
                          (e) => e.theme == theme.name.toLowerCase(),
                          orElse: () => ThemeIcons.classic,
                        )
                        .icon;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: isSelected
                              ? BorderSide(color: theme.primaryColor, width: 2)
                              : const BorderSide(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
                        ),
                        onTap: () {
                          themeController.setTheme(theme.name.toLowerCase());
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          ),
                          child: Icon(iconData, size: 25, color: Colors.white),
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
      ),
    );
  }
}
