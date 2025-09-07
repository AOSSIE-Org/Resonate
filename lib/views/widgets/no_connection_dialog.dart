import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../utils/app_images.dart';

class NoConnectionDialog extends StatelessWidget {
  NoConnectionDialog({super.key});

  final networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
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
                    height: 200,
                    width: 200,
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
                  Obx(
                    () => SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          networkController.tryAgain();
                        },
                        child: networkController.isLoading.value
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
