import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/delete_account_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/l10n/app_localizations.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthStateController authStateController = Get.put(AuthStateController());

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.deleteAccount)),
      body: GetBuilder<DeleteAccountController>(
        init: DeleteAccountController(),
        builder: (controller) => Container(
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
                child: Text(
                  AppLocalizations.of(context)!.deleteMyAccount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: UiSizes.size_16,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Text(AppLocalizations.of(context)!.deleteAccountPermanent),
              SizedBox(height: UiSizes.height_40),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  children: [
                    TextSpan(text: AppLocalizations.of(context)!.toConfirmType),
                    TextSpan(
                      text: ' "${authStateController.userName}" ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: AppLocalizations.of(context)!.inTheBoxBelow),
                  ],
                ),
              ),
              SizedBox(height: UiSizes.height_10),
              TextField(
                onChanged: (value) {
                  if (value == authStateController.userName) {
                    controller.isButtonActive.value = true;
                  } else {
                    controller.isButtonActive.value = false;
                  }
                },
                keyboardType: TextInputType.text,
                autocorrect: false,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: UiSizes.width_2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: UiSizes.height_40),
              Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.redAccent.withAlpha(100),
                      disabledBackgroundColor: Colors.redAccent.withAlpha(50),
                    ),
                    onPressed: (controller.isButtonActive.value)
                        ? () {
                            // DO NOT IMPLEMENT THIS WITHOUT PERMISSION
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.iUnderstandDeleteMyAccount,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
