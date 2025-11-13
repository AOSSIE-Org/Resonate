import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  List<Map<String, dynamic>> _getWhisperModels(BuildContext context) {
    return [
      {
        'model': WhisperModel.tiny,
        'name': AppLocalizations.of(context)!.whisperModelTiny,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelTinyDescription,
        'icon': Icons.speed,
      },
      {
        'model': WhisperModel.base,
        'name': AppLocalizations.of(context)!.whisperModelBase,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelBaseDescription,
        'icon': Icons.balance,
      },
      {
        'model': WhisperModel.small,
        'name': AppLocalizations.of(context)!.whisperModelSmall,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelSmallDescription,
        'icon': Icons.high_quality,
      },
      {
        'model': WhisperModel.medium,
        'name': AppLocalizations.of(context)!.whisperModelMedium,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelMediumDescription,
        'icon': Icons.diamond,
      },
      {
        'model': WhisperModel.largeV1,
        'name': AppLocalizations.of(context)!.whisperModelLargeV1,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelLargeV1Description,
        'icon': Icons.star,
      },
      {
        'model': WhisperModel.largeV2,
        'name': AppLocalizations.of(context)!.whisperModelLargeV2,
        'description': AppLocalizations.of(
          context,
        )!.whisperModelLargeV2Description,
        'icon': Icons.star,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: UiSizes.width_20,
        top: UiSizes.height_16,
        bottom: UiSizes.height_10,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black54
              : Colors.white54,
          fontWeight: FontWeight.bold,
          fontSize: UiSizes.size_14,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: UiSizes.height_30,
      thickness: 10,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black.withValues(alpha: 0.04)
          : Colors.white.withValues(alpha: 0.04),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appSettings)),
      body: ListView(
        children: [
          // Language Selection Section
          _buildSectionTitle(AppLocalizations.of(context)!.selectLanguage),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20,
              vertical: UiSizes.height_8,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_16,
              vertical: UiSizes.height_8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: LanguagePickerDropdown(
              initialValue: Language.fromIsoCode(
                Get.locale?.languageCode ?? "en",
              ),
              onValuePicked: (Language language) async {
                Get.updateLocale(Locale(language.isoCode));

                await FlutterSecureStorage().write(
                  key: "languageLocale",
                  value: language.isoCode,
                );
              },
              languages: AppLocalizations.supportedLocales
                  .map((locale) => Language.fromIsoCode(locale.languageCode))
                  .toList(),
            ),
          ),

          _buildDivider(),

          // Whisper Model Selection Section
          _buildSectionTitle(AppLocalizations.of(context)!.transcriptionModel),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_10,
              vertical: UiSizes.height_8,
            ),
            child: Text(
              AppLocalizations.of(context)!.transcriptionModelDescription,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54,
                fontSize: UiSizes.size_12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Whisper Model Cards
          Builder(
            builder: (context) {
              final whisperModels = _getWhisperModels(context);
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: UiSizes.width_10,
                  vertical: UiSizes.height_8,
                ),
                itemCount: whisperModels.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final modelData = whisperModels[index];
                    final bool isSelected =
                        currentWhisperModel.value == modelData['model'];

                    return Container(
                      margin: EdgeInsets.only(bottom: UiSizes.height_12),

                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: UiSizes.height_8,
                          horizontal: UiSizes.width_16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        onTap: () async {
                          currentWhisperModel.value = modelData['model'];

                          await FlutterSecureStorage().write(
                            key: "whisperModel",
                            value: modelData['model'].modelName,
                          );
                        },
                        leading: Container(
                          padding: EdgeInsets.all(UiSizes.width_10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            modelData['icon'],
                            size: UiSizes.size_24,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        title: Text(
                          modelData['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: UiSizes.size_16,
                            color: isSelected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          modelData['description'],
                          style: TextStyle(
                            fontSize: UiSizes.size_12,
                            color: isSelected
                                ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withValues(alpha: 0.7)
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                                size: UiSizes.size_28,
                              )
                            : Icon(
                                Icons.circle_outlined,
                                color: Theme.of(context).colorScheme.outline,
                                size: UiSizes.size_28,
                              ),
                      ),
                    );
                  });
                },
              );
            },
          ),

          _buildDivider(),

          // Info Section
          Padding(
            padding: EdgeInsets.all(UiSizes.width_20),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: EdgeInsets.all(UiSizes.width_16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: UiSizes.size_24,
                    ),
                    SizedBox(width: UiSizes.width_10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.modelDownloadInfo,
                        style: TextStyle(
                          fontSize: UiSizes.size_12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
