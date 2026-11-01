import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/shell/viewmodel/network_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class NoConnectionDialog extends ConsumerWidget {
  const NoConnectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(networkProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_20,
                horizontal: UiSizes.width_40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.noConnectionImage,
                    height: UiSizes.height_200,
                    width: UiSizes.width_200,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.modulate,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.noConnection,
                    style: TextStyle(
                      fontSize: UiSizes.size_40,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.connectionError,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: UiSizes.height_60),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () =>
                          ref.read(networkProvider.notifier).tryAgain(),
                      child: isLoading
                          ? Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: UiSizes.size_40,
                                  ),
                            )
                          : Text(AppLocalizations.of(context)!.tryAgain),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
