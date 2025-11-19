import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/enums/room_state.dart';

@GenerateMocks([Databases, Client])
void main() {
  Get.testMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return Directory.systemTemp.path;
          }
          return null;
        },
      );

  group('RoomsController - Search Functionality', () {
    late RoomsController controller;
    late ThemeController themeController;

    final mockRooms = [
      AppwriteRoom(
        id: 'room1',
        name: 'Flutter Development',
        description: 'Discussing Flutter app development and best practices',
        totalParticipants: 5,
        tags: ['flutter', 'development'],
        state: RoomState.live,
        memberAvatarUrls: ['url1', 'url2'],
        isUserAdmin: false,
        reportedUsers: [],
      ),
      AppwriteRoom(
        id: 'room2',
        name: 'Music Discussion',
        description: 'Talk about your favorite music and artists',
        totalParticipants: 3,
        tags: ['music', 'discussion'],
        state: RoomState.live,
        memberAvatarUrls: ['url1'],
        isUserAdmin: false,
        reportedUsers: [],
      ),
      AppwriteRoom(
        id: 'room3',
        name: 'Tech Talk',
        description: 'General technology discussions and news',
        totalParticipants: 7,
        tags: ['tech', 'news'],
        state: RoomState.live,
        memberAvatarUrls: ['url1', 'url2', 'url3'],
        isUserAdmin: false,
        reportedUsers: [],
      ),
    ];

    setUpAll(() async {
      await GetStorage.init('test_storage_rooms');
    });

    setUp(() {
      themeController = ThemeController();
      Get.put<ThemeController>(themeController);
      controller = RoomsController();
      controller.rooms.value = List.from(mockRooms);
    });

    tearDown(() {
      Get.reset();
    });

    test('should filter rooms by name', () {
      controller.searchLiveRooms('Flutter');
      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms[0].name, 'Flutter Development');
    });

    test('should filter rooms by description', () {
      controller.searchLiveRooms('music');
      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms[0].name, 'Music Discussion');
    });

    test('should be case-insensitive', () {
      controller.searchLiveRooms('FLUTTER');
      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms[0].name, 'Flutter Development');
    });

    test('should return all rooms when query is empty', () {
      controller.searchLiveRooms('');
      expect(controller.filteredRooms.length, 3);
    });

    test('should return empty list when no matches found', () {
      controller.searchLiveRooms('NonExistentRoom');
      expect(controller.filteredRooms.length, 0);
    });

    test('should match partial strings', () {
      controller.searchLiveRooms('Tech');
      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms[0].name, 'Tech Talk');
    });

    test('should set searchBarIsEmpty flag correctly', () {
      expect(controller.searchBarIsEmpty.value, true);
      controller.searchLiveRooms('Flutter');
      expect(controller.searchBarIsEmpty.value, false);
    });

    test('should clear search results', () {
      controller.searchLiveRooms('Flutter');
      expect(controller.searchBarIsEmpty.value, false);
      expect(controller.filteredRooms.length, 1);

      controller.clearLiveSearch();
      expect(controller.searchBarIsEmpty.value, true);
      expect(controller.filteredRooms.length, 3);
    });

    test('should handle special characters in search query', () {
      controller.searchLiveRooms('Development & practices');
      expect(controller.filteredRooms.length, 0);
    });

    test('should match across multiple fields', () {
      controller.searchLiveRooms('discuss');
      expect(controller.filteredRooms.length, 3);
      expect(
        controller.filteredRooms.any(
          (room) => room.name == 'Flutter Development',
        ),
        true,
      );
      expect(
        controller.filteredRooms.any((room) => room.name == 'Music Discussion'),
        true,
      );
      expect(
        controller.filteredRooms.any((room) => room.name == 'Tech Talk'),
        true,
      );
    });
  });
}
