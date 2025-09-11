import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/models/themes_model.dart';
import 'package:resonate/themes/theme_enum.dart';
import 'package:resonate/themes/theme_list.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  final List<ThemeModel> list = ThemeList.themesList;
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: (themeController.currentTheme.value == 'none')
            ? const Text("none")
            : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final bool isSelected =
                  themeController.currentTheme.value == list[index].name.toLowerCase();
                final String title = AppLocalizations.of(
                  context,
                )!.chooseTheme("${list[index].name.toLowerCase()}Theme");

                return _listTileBuilder(
                  themeName: title,
                  isSelected: isSelected,
                  theme: list[index]
                );
              },
            ),
        ),
      ),
    );
  }

  Widget _listTileBuilder({
    required bool isSelected,
    required String themeName,
    required ThemeModel theme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(14),
          side: BorderSide.lerp(
            const BorderSide(color: Colors.transparent, width: 2),
            BorderSide(color: theme.primaryColor, width: 2),
            isSelected ? 1.5 : 0.0,
          ),
        ),
        onTap: () {
          themeController.setTheme(theme.name.toLowerCase());
        },
        leading: _leadingIconBuilder(
          themeName: themeName,
          theme: theme,
        ),
        trailing: _trailingIconBuilder(theme: theme, isSelected: isSelected),
        tileColor: isSelected ? theme.primaryColor : Colors.black26,
        selected: isSelected,
        selectedColor: theme.primaryColor,
        selectedTileColor: theme.secondaryColor,
        title: _titleBuilder(
          themeName: themeName,
          theme: theme,
          isSelected: isSelected,
        ),
      ),
    );
  }

  Widget _titleBuilder({
    required String themeName,
    required ThemeModel theme,
    bool isSelected = false
  }) {
    Widget colorDots(Color color, {bool isBorder = false}) {
      final double size = 10;
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: (isBorder && isSelected) ? Border.all(
              color: theme.primaryColor,
              width: 0.5
            ) : null,
        ),
      );
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(themeName, style: TextStyle(fontSize: 18),),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            colorDots(theme.primaryColor),
            colorDots(theme.secondaryColor, isBorder: true),
            colorDots(theme.onPrimaryColor),
          ],
        )
      ],
    );
  }

  Widget _trailingIconBuilder({
    required ThemeModel theme,
    required bool isSelected,
  }) {
    Widget nonSelectedIconBuilder() {
      final double size = 30;
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 27,
              spreadRadius: -5,
              offset: Offset(0, 13),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 16,
              spreadRadius: -8,
              offset: Offset(0, 8),
            )
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      );
    }

    if (isSelected) {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(38, 57, 77, 1),
              blurRadius: 30,
              spreadRadius: -10,
              offset: Offset(0, 20),
            )
          ],
          color: theme.primaryColor,
          shape: BoxShape.circle
        ),
        child: Icon(Icons.check, color: theme.onPrimaryColor,),
      );
    }

    return nonSelectedIconBuilder();

  }

  Widget _leadingIconBuilder({
    required String themeName,
    required ThemeModel theme,
  }) {
    final IconData iconData = ThemeIcons.values.where((element) => element.theme ==
        themeName
          .toLowerCase(),).first.icon;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Icon(
        iconData, size: 25,
        color: Colors.white,
      ),
    );
  }
}
