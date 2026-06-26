import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/pages/create_chapter_page.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/view/widgets/cover_image_picker.dart';
import 'package:resonate/features/stories/viewmodel/create_story_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final List<Chapter> chapters = [];
  StoryCategory selectedCategory = StoryCategory.drama;
  File? coverImage;
  bool _isCreating = false;

  @override
  void dispose() {
    titleController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  void _addChapter(Chapter chapter) => setState(() => chapters.add(chapter));

  Future<void> _pickCoverImage() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected != null) setState(() => coverImage = File(selected.path));
  }

  Future<void> _createStory() async {
    if (_isCreating) return;
    final l10n = AppLocalizations.of(context)!;
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        chapters.isEmpty) {
      customSnackbar(
        l10n.error,
        l10n.fillAllRequiredFieldsAndChapter,
        LogType.error,
      );
      return;
    }

    final totalPlayDuration = chapters.fold(
      0,
      (sum, chapter) => sum + chapter.playDuration,
    );
    final router = GoRouter.of(context);
    setState(() => _isCreating = true);
    try {
      await ref
          .read(createStoryProvider.notifier)
          .createStory(
            title: titleController.text,
            description: aboutController.text,
            category: selectedCategory,
            coverImgRef: coverImage?.path ?? storyCoverImagePlaceholderUrl,
            storyPlayDuration: totalPlayDuration,
            chapters: chapters,
          );
    } catch (e) {
      log('Story creation failed: $e');
      if (mounted) setState(() => _isCreating = false);
      customSnackbar(l10n.error, e.toString(), LogType.error);
      return;
    }
    router.go(RoutePaths.tabview);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = TextStyle(color: colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.createYourStory),
        ),
        body: Padding(
          padding: EdgeInsets.all(UiSizes.width_16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: l10n.titleRequired,
                    labelStyle: labelStyle,
                    enabledBorder: _border(colorScheme.inversePrimary),
                    focusedBorder: _border(colorScheme.primary),
                    counterText: '',
                  ),
                  maxLength: 100,
                ),
                SizedBox(height: UiSizes.height_30),
                DropdownButtonFormField<StoryCategory>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    border: _border(colorScheme.inversePrimary),
                    enabledBorder: _border(colorScheme.inversePrimary),
                    focusedBorder: _border(colorScheme.primary),
                  ),
                  items: StoryCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            l10n.storyCategory(category.name),
                            style: labelStyle,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedCategory = value!),
                ),
                SizedBox(height: UiSizes.height_30),
                TextField(
                  controller: aboutController,
                  maxLength: 2000,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.aboutRequired,
                    labelStyle: labelStyle,
                    enabledBorder: _border(colorScheme.inversePrimary),
                    focusedBorder: _border(colorScheme.primary),
                    counterText: '',
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                CoverImagePicker(
                  image: coverImage,
                  placeholderUrl: storyCoverImagePlaceholderUrl,
                  onTap: _pickCoverImage,
                ),
                SizedBox(height: UiSizes.height_30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: UiSizes.height_8),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          chapter.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chapter.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          formatPlayDuration(chapter.playDuration),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: UiSizes.height_10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateChapterPage(onChapterCreated: _addChapter),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addChapter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createStory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: _isCreating
                        ? SizedBox(
                            height: UiSizes.size_18,
                            width: UiSizes.size_18,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(l10n.createStory),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: color),
  );
}
