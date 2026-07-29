import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/services/execute_function.dart';
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';

import 'execute_function_test.mocks.dart';

models.Execution _execution({required int code, required String body}) =>
    models.Execution(
      $id: 'exec',
      $createdAt: '2023-01-01',
      $updatedAt: '2023-01-01',
      $permissions: const [],
      functionId: 'func',
      trigger: enums.ExecutionTrigger.http,
      status: enums.ExecutionStatus.completed,
      requestMethod: 'POST',
      requestPath: '/',
      requestHeaders: const [],
      responseStatusCode: code,
      responseBody: body,
      responseHeaders: const [],
      logs: '',
      errors: '',
      duration: 0.1,
      deploymentId: 'dep',
    );

@GenerateMocks([Functions])
void main() {
  late MockFunctions functions;

  setUp(() => functions = MockFunctions());

  group('Functions.execute', () {
    test('decodes and returns the JSON body on a 200', () async {
      final data = {'ok': true, 'name': 'room-1'};
      when(functions.createExecution(
        functionId: 'fn',
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution(code: 200, body: jsonEncode(data)));

      final result = await functions.execute(functionId: 'fn', body: {'a': 1});

      expect(result, data);
      final captured = verify(functions.createExecution(
        functionId: 'fn',
        body: captureAnyNamed('body'),
      )).captured.single as String;
      expect(jsonDecode(captured), {'a': 1});
    });

    test('throws when the status code is not 200', () async {
      when(functions.createExecution(
        functionId: 'fn',
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution(code: 400, body: 'Bad Request'));

      expect(
        () => functions.execute(functionId: 'fn'),
        throwsA(isA<Exception>()),
      );
    });

    test('maps an AppwriteException to an Exception', () async {
      when(functions.createExecution(
        functionId: 'fn',
        body: anyNamed('body'),
      )).thenThrow(AppwriteException('connection failed'));

      expect(
        () => functions.execute(functionId: 'fn'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RoomJoinService', () {
    test('joins via the joinRoom function and returns the decoded body',
        () async {
      when(functions.createExecution(
        functionId: joinRoomServiceId,
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => _execution(code: 200, body: jsonEncode({'joined': true})),
      );

      final service = RoomJoinService(functions: functions);
      final result = await service.joinRoom('room-1', 'user-1');

      expect(result, {'joined': true});
      final body = verify(functions.createExecution(
        functionId: joinRoomServiceId,
        body: captureAnyNamed('body'),
      )).captured.single as String;
      expect(jsonDecode(body), {'roomName': 'room-1', 'uid': 'user-1'});
    });
  });
}
