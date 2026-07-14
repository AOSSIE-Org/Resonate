import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/profile/model/edit_profile_state.dart';
import 'package:resonate/features/profile/viewmodel/edit_profile_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/debouncer.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/loading_dialog.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 800);
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController.text = (user?.displayName ?? '').trim();
    _usernameController.text = (user?.userName ?? '').trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    final notifier = ref.read(editProfileProvider.notifier);
    return notifier.isProfilePictureChanged() ||
        notifier.isUsernameChanged(_usernameController.text) ||
        notifier.isDisplayNameChanged(_nameController.text);
  }

  void _onUsernameChanged(String value, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final notifier = ref.read(editProfileProvider.notifier);
    final trimmed = value.trim();

    if (!value.isValidUsername()) {
      notifier.setUsernameAvailable(false);
      notifier.setUsernameChecking(false);
      return;
    }

    notifier.setUsernameChecking(true);
    notifier.setUsernameAvailable(false);
    _debouncer.run(() async {
      final available = await notifier.isUsernameAvailable(trimmed);
      notifier.setUsernameChecking(false);
      notifier.setUsernameAvailable(available);
      if (!available) {
        customSnackbar(
          l10n.usernameUnavailable,
          l10n.usernameAlreadyTaken,
          LogType.error,
          snackbarDuration: 1,
        );
      }
    });
  }

  Future<CroppedFile?> _cropImage(String imagePath, AppLocalizations l10n) {
    return ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(toolbarTitle: l10n.cropImage),
        IOSUiSettings(minimumAspectRatio: 1.0, title: l10n.cropImage),
      ],
    );
  }

  Future<void> _pickAndSet(ImageSource source, AppLocalizations l10n) async {
    loadingDialog(context);
    try {
      final file = await _imagePicker.pickImage(source: source);
      if (file == null) return;
      final cropped = await _cropImage(file.path, l10n);
      if (cropped != null) {
        ref.read(editProfileProvider.notifier).setProfileImagePath(cropped.path);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final view = View.of(context);
    try {
      final result = await ref.read(editProfileProvider.notifier).saveProfile(
            name: _nameController.text,
            username: _usernameController.text,
          );
      if (!mounted) return;
      if (result == EditProfileSaveResult.saved) {
        customSnackbar(
          l10n.profileSavedSuccessfully,
          l10n.profileUpdatedSuccessfully,
          LogType.success,
        );
        SemanticsService.sendAnnouncement(
          view,
          l10n.profileUpdatedSuccessfully,
          ui.TextDirection.ltr,
        );
      } else {
        customSnackbar(l10n.profileUpToDate, l10n.noChangesToSave, LogType.info);
        SemanticsService.sendAnnouncement(
          view,
          l10n.noChangesToSave,
          ui.TextDirection.ltr,
        );
      }
    } catch (e) {
      if (!mounted) return;
      customSnackbar(l10n.error, e.toString(), LogType.error);
      SemanticsService.sendAnnouncement(view, e.toString(), ui.TextDirection.ltr);
    }
  }

  Future<void> _saveChangesDialog(AppLocalizations l10n) async {
    await showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.saveChanges,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        content: Text(
          textAlign: TextAlign.center,
          l10n.unsavedChangesWarning,
          style: TextStyle(fontSize: UiSizes.size_14),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.of(context).pop();
                },
                child: Text(
                  l10n.discard,
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _save();
                },
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showImageSourceSheet(AppLocalizations l10n, String? currentImageUrl) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: UiSizes.height_30,
          bottom: UiSizes.height_60,
        ),
        children: [
          Text(
            l10n.changeProfilePicture,
            style: TextStyle(
              fontSize: UiSizes.size_20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UiSizes.height_30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    tooltip: l10n.clickPictureCamera,
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _pickAndSet(ImageSource.camera, l10n);
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    iconSize: UiSizes.size_56,
                  ),
                  Text(l10n.camera),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    tooltip: l10n.pickImageGallery,
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _pickAndSet(ImageSource.gallery, l10n);
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    iconSize: UiSizes.size_56,
                  ),
                  Text(l10n.gallery),
                ],
              ),
              if (currentImageUrl != null)
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        ref
                            .read(editProfileProvider.notifier)
                            .removeProfilePicture();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      iconSize: UiSizes.size_56,
                    ),
                    Text(l10n.remove),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _avatarImage(EditProfileState state, String? profileImageUrl) {
    if (state.profileImagePath != null) {
      return FileImage(File(state.profileImagePath!));
    }
    if (state.removeImage ||
        profileImageUrl == null ||
        profileImageUrl.isEmpty) {
      return NetworkImage(ref.watch(userProfileImagePlaceholderUrlProvider));
    }
    return NetworkImage(profileImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(editProfileProvider);
    final user = ref.watch(currentUserProvider);

    return PopScope(
      canPop: !(state.isLoading || _hasUnsavedChanges()),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!state.isLoading && _hasUnsavedChanges()) {
          await _saveChangesDialog(l10n);
        } else if (!state.isLoading && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(l10n.editProfile)),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: UiSizes.height_20),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundImage: _avatarImage(state, user?.profileImageUrl),
                    radius: UiSizes.width_80,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Semantics(
                        label: l10n.uploadProfilePicture,
                        child: GestureDetector(
                          onTap: () =>
                              _showImageSourceSheet(l10n, user?.profileImageUrl),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_40),
                  TextFormField(
                    validator: (value) =>
                        value!.isNotEmpty ? null : l10n.requiredField,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      prefixIcon: const Icon(Icons.abc_rounded),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 36,
                    validator: (value) {
                      if (!value!.hasMinUsernameLength()) {
                        return l10n.usernameCharacterLimit;
                      }
                      if (!value.hasValidUsernameFormat()) {
                        return l10n.usernameInvalidFormat;
                      }
                      return null;
                    },
                    controller: _usernameController,
                    onChanged: (value) => _onUsernameChanged(value, l10n),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: state.usernameChecking
                          ? Padding(
                              padding: EdgeInsets.all(UiSizes.width_10),
                              child: SizedBox(
                                width: UiSizes.size_20,
                                height: UiSizes.size_20,
                                child: CircularProgressIndicator(
                                  strokeWidth: UiSizes.width_2,
                                ),
                              ),
                            )
                          : state.usernameAvailable
                              ? const Icon(
                                  Icons.verified_outlined,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton(
                      onPressed: () => context.push(RoutePaths.changeEmail),
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromHeight(UiSizes.height_60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.changeEmail),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_60),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: (!state.isLoading && state.usernameAvailable)
                          ? () async => _save()
                          : null,
                      child: state.isLoading
                          ? Center(
                              child: LoadingAnimationWidget
                                  .horizontalRotatingDots(
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: UiSizes.size_40,
                              ),
                            )
                          : Text(l10n.saveChanges),
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
