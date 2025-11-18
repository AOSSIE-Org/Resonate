import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/themes/theme_controller.dart';

import 'upcoming_controller_tests.mocks.dart';

@GenerateMocks([
  Databases,
  TablesDB,
  Account,
  Client,
  FirebaseMessaging,
  Realtime,
])
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
  final mockRooms = [
    AppwriteUpcommingRoom(
      id: 'room1',
      name: 'Future Tech Discussion',
      description: 'Exploring upcoming technology trends and innovations',
      isTime: true,
      scheduledDateTime: DateTime.now().add(Duration(days: 1)),
      totalSubscriberCount: 10,
      tags: ['tech', 'future'],
      subscribersAvatarUrls: ['url1', 'url2'],
      userIsCreator: true,
      hasUserSubscribed: false,
    ),
    AppwriteUpcommingRoom(
      id: 'room2',
      name: 'Music Jam Session',
      description: 'Live music performance and collaboration',
      isTime: true,
      scheduledDateTime: DateTime.now().add(Duration(days: 2)),
      totalSubscriberCount: 5,
      tags: ['music', 'live'],
      subscribersAvatarUrls: ['url1'],
      userIsCreator: false,
      hasUserSubscribed: true,
    ),
    AppwriteUpcommingRoom(
      id: 'room3',
      name: 'Book Club Meeting',
      description: 'Discussing the latest bestseller books',
      isTime: false,
      scheduledDateTime: DateTime.now().add(Duration(days: 3)),
      totalSubscriberCount: 8,
      tags: ['books', 'discussion'],
      subscribersAvatarUrls: ['url1', 'url2', 'url3'],
      userIsCreator: true,
      hasUserSubscribed: false,
    ),
  ];

  group('UpcomingRoomsController - Remove Room Functionality', () {
    late UpcomingRoomsController controller;
    late GetStorage testStorage;
    late MockDatabases mockDatabases;
    late MockTablesDB mockTables;
    late MockAccount mockAccount;
    late MockClient mockClient;
    late MockFirebaseMessaging mockMessaging;
    late AuthStateController authStateController;
    late CreateRoomController createRoomController;
    late TabViewController tabViewController;
    late ThemeController themeController;
    late RoomsController roomsController;

    setUpAll(() async {
      await GetStorage.init('test_storage');
    });

    setUp(() {
      testStorage = GetStorage('test_storage');
      testStorage.erase(); //clear before each test
      mockDatabases = MockDatabases();
      mockTables = MockTablesDB();
      mockAccount = MockAccount();
      mockClient = MockClient();
      mockMessaging = MockFirebaseMessaging();
      authStateController = AuthStateController(
        account: mockAccount,
        tables: mockTables,
        client: mockClient,
        messaging: mockMessaging,
      );
      tabViewController = TabViewController();
      themeController = ThemeController();
      Get.put<ThemeController>(themeController);
      createRoomController = CreateRoomController(
        themeController: themeController,
      );
      roomsController = RoomsController();
      controller = UpcomingRoomsController(
        authStateController: authStateController,
        createRoomController: createRoomController,
        tabViewController: tabViewController,
        themeController: themeController,
        roomsController: roomsController,
        databases: mockDatabases,
        messaging: mockMessaging,
        storage: testStorage,
      );
    });

    tearDown(() {
      Get.reset();
      testStorage.erase();
    });

    test('should remove room from upcomingRooms list', () async {
      controller.upcomingRooms.value = List.from(mockRooms);
      expect(controller.upcomingRooms.length, 3);
      await controller.removeUpcomingRoom('room2');
      expect(controller.upcomingRooms.length, 2);
      expect(controller.upcomingRooms.any((room) => room.id == 'room2'), false);
      expect(controller.upcomingRooms.any((room) => room.id == 'room1'), true);
      expect(controller.upcomingRooms.any((room) => room.id == 'room3'), true);
    });

    test('should add removed room ID to storage', () async {
      controller.upcomingRooms.value = List.from(mockRooms);
      await controller.removeUpcomingRoom('room1');
      List<dynamic>? removedRooms = testStorage.read('removed_upcoming_rooms');
      expect(removedRooms, isNotNull);
      expect(removedRooms, contains('room1'));
    });

    test('should not add duplicate room IDs to storage', () async {
      controller.upcomingRooms.value = List.from(mockRooms);
      await controller.removeUpcomingRoom('room1');
      controller.upcomingRooms.add(mockRooms[0]);
      await controller.removeUpcomingRoom('room1');
      List<dynamic>? removedRooms = testStorage.read('removed_upcoming_rooms');
      expect(removedRooms?.where((id) => id == 'room1').length, 1);
    });

    test('should remove multiple rooms independently', () async {
      controller.upcomingRooms.value = List.from(mockRooms);
      await controller.removeUpcomingRoom('room1');
      await controller.removeUpcomingRoom('room3');
      expect(controller.upcomingRooms.length, 1);
      expect(controller.upcomingRooms[0].id, 'room2');
      List<dynamic>? removedRooms = testStorage.read('removed_upcoming_rooms');
      expect(removedRooms?.length, 2);
      expect(removedRooms, containsAll(['room1', 'room3']));
    });

    test('should handle removing non-existent room gracefully', () async {
      controller.upcomingRooms.value = List.from(mockRooms);
      await controller.removeUpcomingRoom('non-existent-room');
      expect(controller.upcomingRooms.length, 3);
      List<dynamic>? removedRooms = testStorage.read('removed_upcoming_rooms');
      expect(removedRooms, contains('non-existent-room'));
    });

    test(
      'should persist removed rooms list across controller instances',
      () async {
        controller.upcomingRooms.value = List.from(mockRooms);
        await controller.removeUpcomingRoom('room2');
        List<dynamic>? removedRooms = testStorage.read(
          'removed_upcoming_rooms',
        );
        expect(removedRooms, contains('room2'));
        Get.delete<UpcomingRoomsController>();
        UpcomingRoomsController(
          authStateController: authStateController,
          createRoomController: createRoomController,
          tabViewController: tabViewController,
          themeController: themeController,
          roomsController: roomsController,
          databases: mockDatabases,
          messaging: mockMessaging,
          storage: testStorage,
        );
        removedRooms = testStorage.read('removed_upcoming_rooms');
        expect(removedRooms, contains('room2'));
        Get.delete<UpcomingRoomsController>();
      },
    );
  });

  group('UpcomingRoomsController - Search Functionality', () {
    late UpcomingRoomsController controller;
    late GetStorage testStorage;
    late MockDatabases mockDatabases;
    late MockTablesDB mockTables;
    late MockAccount mockAccount;
    late MockClient mockClient;
    late MockFirebaseMessaging mockMessaging;
    late AuthStateController authStateController;
    late CreateRoomController createRoomController;
    late TabViewController tabViewController;
    late ThemeController themeController;
    late RoomsController roomsController;

    setUpAll(() async {
      await GetStorage.init('test_storage_search');
    });

    setUp(() {
      testStorage = GetStorage('test_storage_search');
      testStorage.erase();
      mockDatabases = MockDatabases();
      mockTables = MockTablesDB();
      mockAccount = MockAccount();
      mockClient = MockClient();
      mockMessaging = MockFirebaseMessaging();
      authStateController = AuthStateController(
        account: mockAccount,
        tables: mockTables,
        client: mockClient,
        messaging: mockMessaging,
      );
      tabViewController = TabViewController();
      themeController = ThemeController();
      Get.put<ThemeController>(themeController);
      createRoomController = CreateRoomController(
        themeController: themeController,
      );
      roomsController = RoomsController();
      controller = UpcomingRoomsController(
        authStateController: authStateController,
        createRoomController: createRoomController,
        tabViewController: tabViewController,
        themeController: themeController,
        roomsController: roomsController,
        databases: mockDatabases,
        messaging: mockMessaging,
        storage: testStorage,
      );
      controller.upcomingRooms.value = List.from(mockRooms);
    });

    tearDown(() {
      Get.reset();
      testStorage.erase();
    });

    test('should filter upcoming rooms by name', () {
      controller.searchUpcomingRooms('Tech');
      expect(controller.filteredUpcomingRooms.length, 1);
      expect(
        controller.filteredUpcomingRooms[0].name,
        'Future Tech Discussion',
      );
    });

    test('should filter upcoming rooms by description', () {
      controller.searchUpcomingRooms('music');
      expect(controller.filteredUpcomingRooms.length, 1);
      expect(controller.filteredUpcomingRooms[0].name, 'Music Jam Session');
    });

    test('should be case-insensitive for upcoming rooms', () {
      controller.searchUpcomingRooms('BOOK');
      expect(controller.filteredUpcomingRooms.length, 1);
      expect(controller.filteredUpcomingRooms[0].name, 'Book Club Meeting');
    });

    test('should return all upcoming rooms when query is empty', () {
      controller.searchUpcomingRooms('');
      expect(controller.filteredUpcomingRooms.length, 3);
    });

    test(
      'should return empty list when no matches found in upcoming rooms',
      () {
        controller.searchUpcomingRooms('NonExistent');
        expect(controller.filteredUpcomingRooms.length, 0);
      },
    );

    test('should match partial strings in upcoming rooms', () {
      controller.searchUpcomingRooms('Disc');
      expect(controller.filteredUpcomingRooms.length, 2);
    });

    test('should clear upcoming search results', () {
      controller.searchUpcomingRooms('Music');
      expect(controller.searchBarIsEmpty.value, false);
      expect(controller.filteredUpcomingRooms.length, 1);

      controller.clearUpcomingSearch();
      expect(controller.searchBarIsEmpty.value, true);
      expect(controller.filteredUpcomingRooms.length, 3);
    });

    test('should match across multiple fields in upcoming rooms', () {
      controller.searchUpcomingRooms('discuss');
      expect(controller.filteredUpcomingRooms.length, 2);
      expect(
        controller.filteredUpcomingRooms.any(
          (room) => room.name == 'Future Tech Discussion',
        ),
        true,
      );
      expect(
        controller.filteredUpcomingRooms.any(
          (room) => room.name == 'Book Club Meeting',
        ),
        true,
      );
    });
  });
}
