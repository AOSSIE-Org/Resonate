import 'dart:developer';
import 'dart:ui' as ui;

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class OnboardingController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  AuthUser get authStateController => requireCurrentAuthUser;
  final themeController = Get.find<ThemeController>();
  late final Storage storage;
  late final TablesDB tables;

  RxBool isLoading = false.obs;
  String? profileImagePath;
  String? uniqueIdForProfileImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController imageController = TextEditingController(text: "");
  TextEditingController dobController = TextEditingController(text: "");

  final GlobalKey<FormState> userOnboardingFormKey = GlobalKey<FormState>();

  Rx<bool> usernameAvailable = false.obs;
  Rx<bool> usernameAvailableChecking = false.obs;

  @override
  void onInit() async {
    super.onInit();
    storage = Storage(rootContainer.read(appwriteClientProvider));
    tables = TablesDB(rootContainer.read(appwriteClientProvider));
  }

  Future<void> chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = DateFormat(
        "dd-MM-yyyy",
      ).format(pickedDate).toString();
    }
  }

  Future<void> saveProfile() async {
    if (!userOnboardingFormKey.currentState!.validate()) {
      return;
    }
    var usernameAvail = await isUsernameAvailable(
      usernameController.text.trim(),
    );
    if (!usernameAvail) {
      usernameAvailable.value = false;
      customSnackbar(
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.usernameUnavailable,
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.usernameInvalidOrTaken,
        LogType.error,
      );

      SemanticsService.announce(
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.usernameInvalidOrTaken,
        ui.TextDirection.ltr,
      );
      return;
    }
    try {
      isLoading.value = true;

      // Update username collection
      await tables.createRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: usernameController.text.trim(),
        data: {"email": authStateController.email},
      );
      //Update User Meta Data
      if (profileImagePath != null) {
        uniqueIdForProfileImage =
            authStateController.uid! +
            DateTime.now().millisecondsSinceEpoch.toString();

        final profileImage = await storage.createFile(
          bucketId: userProfileImageBucketId,
          fileId: uniqueIdForProfileImage!,
          file: InputFile.fromPath(
            path: profileImagePath!,
            filename: "${authStateController.email}.jpeg",
          ),
        );
        imageController.text =
            "$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${profileImage.$id}/view?project=$appwriteProjectId";
      } else {
        imageController.text = themeController.userProfileImagePlaceholderUrl;
      }

      // Update User meta data
      await rootContainer.read(appwriteAccountProvider).updateName(
        name: nameController.text.trim(),
      );
      //log(authStateController.uid!);
      await tables.createRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: authStateController.uid!,
        data: {
          "name": nameController.text.trim(),
          "username": usernameController.text.trim(),
          "profileImageUrl": imageController.text,
          "dob": dobController.text,
          "email": authStateController.email,
          "profileImageID": uniqueIdForProfileImage,
        },
      );
      await rootContainer.read(appwriteAccountProvider).updatePrefs(
        prefs: {"isUserProfileComplete": true},
      );
      // Set user profile in authStateController
      await rootContainer.read(authProvider.notifier).refresh();
      customSnackbar(
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.profileCreatedSuccessfully,
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.userProfileCreatedSuccessfully,
        LogType.success,
      );

      SemanticsService.announce(
        AppLocalizations.of(rootNavigatorKey.currentContext!)!.userProfileCreatedSuccessfully,
        ui.TextDirection.ltr,
      );
      appRouter.go(RoutePaths.tabview);
    } catch (e) {
      if (e.toString().contains('Invalid `documentId` param')) {
        log(e.toString());
        customSnackbar(
          AppLocalizations.of(rootNavigatorKey.currentContext!)!.invalidFormat,
          AppLocalizations.of(rootNavigatorKey.currentContext!)!.usernameAlphanumeric,
          LogType.error,
        );
        SemanticsService.announce(
          AppLocalizations.of(rootNavigatorKey.currentContext!)!.usernameAlphanumeric,
          ui.TextDirection.ltr,
        );
      } else {
        // if (e.)
        log(e.toString());
        customSnackbar(
          AppLocalizations.of(rootNavigatorKey.currentContext!)!.error,
          e.toString(),
          LogType.error,
        );
        SemanticsService.announce(e.toString(), ui.TextDirection.ltr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
      );
      if (file == null) return;
      profileImagePath = file.path;
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      await tables.getRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: username,
      );
      return false;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }
}
