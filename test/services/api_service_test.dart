import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/enums.dart' as enums;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/services/api_service.dart';
import 'package:resonate/utils/constants.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([Functions])
void main() {
  late ApiService apiService;
  late MockFunctions mockFunctions;

  setUp(() {
    mockFunctions = MockFunctions();
    // Inject the mock Functions client
    apiService = ApiService(functions: mockFunctions);
  });

  group('ApiService', () {
    const tRoomName = 'Test Room';
    const tRoomDescription = 'Test Description';
    const tAdminUid = 'admin-uid';
    const tTags = ['test'];
    const tToken = 'test-token';
    const tAppwriteRoomDocId = 'room-doc-id';
    const tAppwriteRoomId = 'room-id';
    
    // Helper to create a successful execution response
    models.Execution createSuccessExecution(Map<String, dynamic> data) {
      return models.Execution(
        $id: 'exec-id',
        $createdAt: '2023-01-01',
        $updatedAt: '2023-01-01',
        $permissions: [],
        functionId: 'func-id',
        trigger: enums.ExecutionTrigger.http,
        status: enums.ExecutionStatus.completed,
        requestMethod: 'POST',
        requestPath: '/',
        requestHeaders: [],
        responseStatusCode: 200,
        responseBody: jsonEncode(data),
        responseHeaders: [],
        logs: '',
        errors: '',
        duration: 0.1,
        deploymentId: 'id',
      );
    }
    
    // Helper to create a failed execution response
    models.Execution createFailedExecution(int code, String message) {
      return models.Execution(
        $id: 'exec-id',
        $createdAt: '2023-01-01',
        $updatedAt: '2023-01-01',
        $permissions: [],
        functionId: 'func-id',
        trigger: enums.ExecutionTrigger.http,
        status: enums.ExecutionStatus.failed,
        requestMethod: 'POST',
        requestPath: '/',
        requestHeaders: [],
        responseStatusCode: code,
        responseBody: message,
        responseHeaders: [],
        logs: '',
        errors: '',
        duration: 0.1,
        deploymentId: 'id',
      );
    }

    group('createRoom', () {
      test('should return response data when call is successful', () async {
        final tResponseData = {'id': 'new-room-id', 'name': tRoomName};
        final tExecution = createSuccessExecution(tResponseData);

        when(mockFunctions.createExecution(
          functionId: createRoomServiceId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        final result = await apiService.createRoom(
          tRoomName,
          tRoomDescription,
          tAdminUid,
          tTags,
        );

        expect(result, tResponseData);
        verify(mockFunctions.createExecution(
          functionId: createRoomServiceId,
          body: anyNamed('body'),
        )).called(1);
      });

      test('should throw exception when status code is not 200', () async {
        final tExecution = createFailedExecution(400, 'Bad Request');

        when(mockFunctions.createExecution(
          functionId: createRoomServiceId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        expect(
          () => apiService.createRoom(tRoomName, tRoomDescription, tAdminUid, tTags),
          throwsException,
        );
      });

      test('should throw exception when AppwriteException occurs', () async {
        when(mockFunctions.createExecution(
          functionId: createRoomServiceId,
          body: anyNamed('body'),
        )).thenThrow(AppwriteException('Connection failed'));

        expect(
          () => apiService.createRoom(tRoomName, tRoomDescription, tAdminUid, tTags),
          throwsException,
        );
      });
    });

    group('joinRoom', () {
      test('should return response data when call is successful', () async {
        final tResponseData = {'status': 'joined'};
        final tExecution = createSuccessExecution(tResponseData);

        when(mockFunctions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        final result = await apiService.joinRoom(tRoomName, tAdminUid);

        expect(result, tResponseData);
        verify(mockFunctions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        )).called(1);
      });
    });

    group('deleteRoom', () {
      test('should return response data when call is successful', () async {
        final tResponseData = {'status': 'deleted'};
        final tExecution = createSuccessExecution(tResponseData);

        when(mockFunctions.createExecution(
          functionId: deleteRoomServiceId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        final result = await apiService.deleteRoom(tAppwriteRoomDocId, tToken);

        expect(result, tResponseData);
        verify(mockFunctions.createExecution(
          functionId: deleteRoomServiceId,
          body: anyNamed('body'),
        )).called(1);
      });
    });

    group('createLiveChapterRoom', () {
      test('should return response data when call is successful', () async {
        final tResponseData = {'status': 'created'};
        final tExecution = createSuccessExecution(tResponseData);

        when(mockFunctions.createExecution(
          functionId: createLiveChapterRoomFunctionId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        final result = await apiService.createLiveChapterRoom(tAppwriteRoomId, tAdminUid);

        expect(result, tResponseData);
      });
    });

     group('deleteLiveChapterRoom', () {
      test('should return response data when call is successful', () async {
        final tResponseData = {'status': 'deleted'};
        final tExecution = createSuccessExecution(tResponseData);

        when(mockFunctions.createExecution(
          functionId: deleteLiveChapterRoomFunctionId,
          body: anyNamed('body'),
        )).thenAnswer((_) async => tExecution);

        final result = await apiService.deleteLiveChapterRoom(tAppwriteRoomDocId, tToken);

        expect(result, tResponseData);
      });
    });
  });
}
