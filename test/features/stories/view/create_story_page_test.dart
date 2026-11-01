import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/story_tags.dart';
import 'package:resonate/features/stories/view/pages/create_story_page.dart';
import 'package:resonate/features/stories/view/widgets/tag_input.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'stories_test_helpers.dart';

void main() {
  Future<void> pumpCreateStory(WidgetTester tester) async {
    await pumpStoriesPage(tester, const CreateStoryPage());
    await tester.pumpAndSettle();
  }

  Finder titleField() => find.widgetWithText(TextField, 'Title *');
  Finder aboutField() => find.widgetWithText(TextField, 'About *');
  Finder tagField() => find.widgetWithText(TextField, 'Add a tag');

  Future<void> addTag(WidgetTester tester, String tag) async {
    await tester.ensureVisible(tagField());
    await tester.pumpAndSettle();
    await tester.enterText(tagField(), tag);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  List<String> chipLabels(WidgetTester tester) => tester
      .widgetList<InputChip>(find.byType(InputChip))
      .map((c) => (c.label as Text).data!)
      .toList();

  group('the form', () {
    testStoryWidget('offers a title, category, about, tags and a cover', (
      tester,
    ) async {
      await pumpCreateStory(tester);

      expect(find.text('Create Your Story'), findsOneWidget);
      expect(titleField(), findsOneWidget);
      expect(aboutField(), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<StoryCategory>),
        findsOneWidget,
      );
      expect(find.byType(TagInput), findsOneWidget);
      expect(find.text('Add Chapter'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Create Story'),
        findsOneWidget,
      );
    });

    testStoryWidget('starts on the drama category', (tester) async {
      await pumpCreateStory(tester);

      final dropdown = tester.widget<DropdownButtonFormField<StoryCategory>>(
        find.byType(DropdownButtonFormField<StoryCategory>),
      );
      expect(dropdown.initialValue, StoryCategory.drama);
    });

    testStoryWidget('lets the author switch category', (tester) async {
      await pumpCreateStory(tester);

      await tester.tap(find.byType(DropdownButtonFormField<StoryCategory>));
      await tester.pumpAndSettle();
      // The menu repeats every category; the last entry is the open menu's.
      await tester.tap(find.text('Horror').last);
      await tester.pumpAndSettle();

      expect(find.text('Horror'), findsOneWidget);
    });

    // No chapters means nothing to publish, so the button must not start a
    // creation it cannot finish.
    testStoryWidget('creating with nothing filled in does not navigate', (
      tester,
    ) async {
      await pumpCreateStory(tester);

      await tester.ensureVisible(
        find.widgetWithText(ElevatedButton, 'Create Story'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Story'));
      await tester.pumpAndSettle();

      expect(find.text('Create Your Story'), findsOneWidget);
    });
  });

  group('tags', () {
    testStoryWidget('start empty', (tester) async {
      await pumpCreateStory(tester);

      expect(find.byType(InputChip), findsNothing);
    });

    testStoryWidget('submitting the field adds a chip', (tester) async {
      await pumpCreateStory(tester);

      await addTag(tester, 'mystery');

      expect(chipLabels(tester), ['mystery']);
    });

    // normalizeStoryTag lowercases and trims, so the chip is the canonical
    // form rather than what was typed.
    testStoryWidget('a tag is normalised before it is kept', (tester) async {
      await pumpCreateStory(tester);

      await addTag(tester, '  Mystery  ');

      expect(chipLabels(tester), ['mystery']);
    });

    testStoryWidget('the add button works as well as the keyboard', (
      tester,
    ) async {
      await pumpCreateStory(tester);
      await tester.ensureVisible(tagField());
      await tester.pumpAndSettle();

      await tester.enterText(tagField(), 'thriller');
      await tester.tap(find.byTooltip('Add a tag'));
      await tester.pumpAndSettle();

      expect(chipLabels(tester), ['thriller']);
    });

    testStoryWidget('an empty tag is ignored', (tester) async {
      await pumpCreateStory(tester);

      await addTag(tester, '   ');

      expect(find.byType(InputChip), findsNothing);
    });

    testStoryWidget('the same tag is not added twice', (tester) async {
      await pumpCreateStory(tester);

      await addTag(tester, 'mystery');
      await addTag(tester, 'mystery');

      expect(chipLabels(tester), ['mystery']);
    });

    testStoryWidget('deleting a chip removes the tag', (tester) async {
      await pumpCreateStory(tester);
      await addTag(tester, 'mystery');
      await addTag(tester, 'thriller');

      await tester.tap(find.byTooltip('Remove tag mystery'));
      await tester.pumpAndSettle();

      expect(chipLabels(tester), ['thriller']);
    });

    testStoryWidget('no more than the cap are accepted', (tester) async {
      await pumpCreateStory(tester);

      for (var i = 0; i < kMaxStoryTags + 2; i++) {
        await addTag(tester, 'tag$i');
      }

      expect(chipLabels(tester), hasLength(kMaxStoryTags));
    });

    // The field only clears on a tag that was actually taken, so the author
    // can see what was rejected.
    testStoryWidget('a rejected tag is left in the field', (tester) async {
      await pumpCreateStory(tester);
      for (var i = 0; i < kMaxStoryTags; i++) {
        await addTag(tester, 'tag$i');
      }

      await addTag(tester, 'one-too-many');

      expect(find.text('one-too-many'), findsOneWidget);
    });
  });
}
