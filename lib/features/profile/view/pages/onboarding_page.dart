import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/profile/model/onboarding_state.dart';
import 'package:resonate/features/profile/viewmodel/onboarding_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/debouncer.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 800);
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (file == null) return;
    ref.read(onboardingProvider.notifier).setProfileImagePath(file.path);
  }

  Future<void> _chooseDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dobController.text = DateFormat("dd-MM-yyyy").format(pickedDate);
    }
  }

  void _onUsernameChanged(String value, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final notifier = ref.read(onboardingProvider.notifier);
    if (value.isValidUsername()) {
      notifier.setUsernameChecking(true);
      _debouncer.run(() async {
        final available = await notifier.isUsernameAvailable(value.trim());
        notifier.setUsernameAvailable(available);
        notifier.setUsernameChecking(false);
        if (!available) {
          customSnackbar(
            l10n.usernameUnavailable,
            l10n.usernameInvalidOrTaken,
            LogType.error,
            snackbarDuration: 1,
          );
        }
      });
    } else {
      notifier.setUsernameAvailable(false);
    }
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;
    final view = View.of(context);

    final result = await ref.read(onboardingProvider.notifier).saveProfile(
          name: _nameController.text,
          username: _usernameController.text,
          dob: _dobController.text,
          fallbackImageUrl: ref.read(userProfileImagePlaceholderUrlProvider),
        );
    if (!mounted) return;

    switch (result.status) {
      case OnboardingStatus.success:
        customSnackbar(
          l10n.profileCreatedSuccessfully,
          l10n.userProfileCreatedSuccessfully,
          LogType.success,
        );
        SemanticsService.sendAnnouncement(
          view,
          l10n.userProfileCreatedSuccessfully,
          ui.TextDirection.ltr,
        );
        context.go(RoutePaths.tabview);
      case OnboardingStatus.usernameUnavailable:
        customSnackbar(
          l10n.usernameUnavailable,
          l10n.usernameInvalidOrTaken,
          LogType.error,
        );
        SemanticsService.sendAnnouncement(
          view,
          l10n.usernameInvalidOrTaken,
          ui.TextDirection.ltr,
        );
      case OnboardingStatus.invalidUsernameFormat:
        customSnackbar(
          l10n.invalidFormat,
          l10n.usernameAlphanumeric,
          LogType.error,
        );
        SemanticsService.sendAnnouncement(
          view,
          l10n.usernameAlphanumeric,
          ui.TextDirection.ltr,
        );
      case OnboardingStatus.error:
        customSnackbar(l10n.error, result.message ?? '', LogType.error);
        SemanticsService.sendAnnouncement(
          view,
          result.message ?? '',
          ui.TextDirection.ltr,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_20,
          horizontal: UiSizes.width_20,
        ),
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: UiSizes.height_40),
                Text(
                  l10n.completeYourProfile,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: UiSizes.height_60),
                Semantics(
                  label: l10n.uploadProfilePicture,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundImage: (state.profileImagePath == null)
                          ? NetworkImage(
                              ref.watch(userProfileImagePlaceholderUrlProvider),
                            )
                          : FileImage(File(state.profileImagePath!))
                              as ImageProvider,
                      radius: UiSizes.width_80,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: UiSizes.width_20,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: UiSizes.size_20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: UiSizes.height_40),
                TextFormField(
                  validator: (value) =>
                      value!.isNotEmpty ? null : l10n.enterValidName,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  maxLength: 100,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l10n.name,
                    prefixIcon: const Icon(Icons.abc_rounded),
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                TextFormField(
                  validator: (value) {
                    if (!value!.hasMinUsernameLength()) {
                      return l10n.usernameCharacterLimit;
                    }
                    if (!value.hasValidUsernameFormat()) {
                      return l10n.usernameInvalidFormat;
                    }
                    return null;
                  },
                  maxLength: 36,
                  controller: _usernameController,
                  onChanged: (value) => _onUsernameChanged(value, l10n),
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l10n.username,
                    prefixIcon: const Icon(Icons.person),
                    suffixText:
                        state.usernameChecking ? l10n.checking : null,
                    suffixIcon:
                        state.usernameAvailable && !state.usernameChecking
                            ? const Icon(
                                Icons.verified_outlined,
                                color: Colors.green,
                              )
                            : null,
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                TextFormField(
                  validator: (value) =>
                      value!.isNotEmpty ? null : l10n.enterValidDOB,
                  readOnly: true,
                  onTap: _chooseDate,
                  canRequestFocus: false,
                  controller: _dobController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_month_rounded),
                    labelText: l10n.dateOfBirth,
                  ),
                ),
                SizedBox(height: UiSizes.height_40),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed:
                        state.isLoading ? null : () async => _submit(l10n),
                    child: state.isLoading
                        ? Center(
                            child:
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: UiSizes.size_40,
                            ),
                          )
                        : Text(l10n.submit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
