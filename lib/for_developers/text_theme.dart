import 'package:flutter/material.dart';

class TextThemeForDevs extends StatelessWidget {
  const TextThemeForDevs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Resonate", style: Theme.of(context).textTheme.displayLarge),
            Text("Resonate", style: Theme.of(context).textTheme.displayMedium),
            Text("Resonate", style: Theme.of(context).textTheme.displaySmall),

            Text("Resonate", style: Theme.of(context).textTheme.headlineLarge),
            Text("Resonate", style: Theme.of(context).textTheme.headlineMedium),
            Text("Resonate", style: Theme.of(context).textTheme.headlineSmall),

            Text("Resonate", style: Theme.of(context).textTheme.titleLarge),
            Text("Resonate", style: Theme.of(context).textTheme.titleMedium),
            Text("Resonate", style: Theme.of(context).textTheme.titleSmall),

            Text("Resonate", style: Theme.of(context).textTheme.bodyLarge),
            Text("Resonate", style: Theme.of(context).textTheme.bodyMedium),
            Text("Resonate", style: Theme.of(context).textTheme.bodySmall),

            Text("Resonate", style: Theme.of(context).textTheme.labelLarge),
            Text("Resonate", style: Theme.of(context).textTheme.labelMedium),
            Text("Resonate", style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
