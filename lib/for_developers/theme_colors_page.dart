import 'package:flutter/material.dart';
import 'package:resonate/for_developers/theme_color_model.dart';

class ThemeColorsPage extends StatelessWidget {
  const ThemeColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ThemeColorModel> list = [
      ThemeColorModel(
        color: Theme.of(context).colorScheme.primary,
        name: "primary",
        onColor: Theme.of(context).colorScheme.onPrimary,
      ),
      ThemeColorModel(
        color: Theme.of(context).colorScheme.secondary,
        name: "secondary",
        onColor: Theme.of(context).colorScheme.onSecondary,
      ),
      ThemeColorModel(
        color: Theme.of(context).colorScheme.tertiary,
        name: "tertiary",
        onColor: Theme.of(context).colorScheme.onTertiary,
      ),
      ThemeColorModel(
        color: Theme.of(context).colorScheme.background,
        name: "background",
        onColor: Theme.of(context).colorScheme.onBackground,
      ),
      ThemeColorModel(
        color: Theme.of(context).colorScheme.surface,
        name: "surface",
        onColor: Theme.of(context).colorScheme.onSurface,
      ),

    ];

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 100,
            color: list[index].color,
            child: Text(list[index].name, style: TextStyle(
              color: list[index].onColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
