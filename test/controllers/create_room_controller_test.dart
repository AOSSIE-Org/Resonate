import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/annotations.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/themes/theme_controller.dart';

import 'create_room_controller_test.mocks.dart';

@GenerateMocks([
  ThemeController,
])
void main() {
  final CreateRoomController createRoomController =
      CreateRoomController(themeController: MockThemeController());

  test('test Initial Values', () {
    expect(createRoomController.isLoading.value, false);
    expect(createRoomController.isScheduled.value, false);
    expect(createRoomController.createRoomFormKey.currentState, null);
    expect(createRoomController.nameController.text, '');
    expect(createRoomController.descriptionController.text, '');
    expect(createRoomController.tagsController.getTags, null);
  });
  testWidgets("test validateTag", (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en'),
        Locale('hi'),
      ],
      home: Container(),
    ));

    List<String> testTags = [
      'Football',
      '_Football',
      'Football\$',
      'Amet irure esse cillum reprehenderit ea laboris culpa dolor proident mollit ex.',
      'Football2',
    ];
    expect(
        createRoomController.validateTag(
            testTags[0], tester.element(find.byType(Container))),
        null);
    expect(
        createRoomController.validateTag(
            testTags[1], tester.element(find.byType(Container))),
        '${AppLocalizations.of(tester.element(find.byType(Container)))!.invalidTags} ${testTags[1]}');
    expect(
        createRoomController.validateTag(
            testTags[2], tester.element(find.byType(Container))),
        '${AppLocalizations.of(tester.element(find.byType(Container)))!.invalidTags} ${testTags[2]}');
    expect(
        createRoomController.validateTag(
            testTags[3], tester.element(find.byType(Container))),
        '${AppLocalizations.of(tester.element(find.byType(Container)))!.invalidTags} ${testTags[3]}');
    expect(
        createRoomController.validateTag(
            testTags[4], tester.element(find.byType(Container))),
        null);
  });
}
