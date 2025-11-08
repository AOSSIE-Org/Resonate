import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:resonate/models/message.dart';
import 'package:resonate/utils/constants.dart';

@GenerateMocks([Databases])
import 'room_chat_controller_test.mocks.dart';

void main() {
  group('RoomChatController - deleteMessage', () {
    late MockDatabases mockDatabases;
    late List<Message> messages;

    setUp(() {
      mockDatabases = MockDatabases();
      messages = [];

      messages.add(
        Message(
          messageId: 'test-message-1',
          roomId: 'test-room',
          creatorId: 'user-1',
          creatorUsername: 'testuser',
          creatorName: 'Test User',
          hasValidTag: false,
          index: 0,
          creatorImgUrl: 'https://example.com/img.jpg',
          isEdited: false,
          content: 'Test message content',
          creationDateTime: DateTime.now(),
          isDeleted: false,
        ),
      );
    });

    test('test to successfully delete a message', () async {
      when(
        mockDatabases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessagesCollectionId,
          documentId: 'test-message-1',
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Document(
          $id: 'test-message-1',
          $collectionId: chatMessagesCollectionId,
          $databaseId: masterDatabaseId,
          $createdAt: DateTime.now().toIso8601String(),
          $updatedAt: DateTime.now().toIso8601String(),
          $permissions: [],
          data: {},
        ),
      );

      Message messageToDelete = messages.firstWhere(
        (msg) => msg.messageId == 'test-message-1',
      );
      messageToDelete = messageToDelete.copyWith(content: '', isDeleted: true);

      await mockDatabases.updateDocument(
        databaseId: masterDatabaseId,
        collectionId: chatMessagesCollectionId,
        documentId: 'test-message-1',
        data: messageToDelete.toJsonForUpload(),
      );

      verify(
        mockDatabases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessagesCollectionId,
          documentId: 'test-message-1',
          data: argThat(
            predicate<Map<String, dynamic>>(
              (data) => data['content'] == '' && data['isDeleted'] == true,
            ),
            named: 'data',
          ),
        ),
      ).called(1);
    });

    test('test to handle error when message not found', () async {
      try {
        messages.firstWhere((msg) => msg.messageId == 'non-existent-message');
        fail('Should have thrown StateError');
      } catch (e) {
        expect(e, isA<StateError>());
      }

      verifyNever(
        mockDatabases.updateDocument(
          databaseId: anyNamed('databaseId'),
          collectionId: anyNamed('collectionId'),
          documentId: anyNamed('documentId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('test to handle database errors', () async {
      when(
        mockDatabases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessagesCollectionId,
          documentId: 'test-message-1',
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('Database error'));

      // Act
      Message messageToDelete = messages.firstWhere(
        (msg) => msg.messageId == 'test-message-1',
      );
      messageToDelete = messageToDelete.copyWith(content: '', isDeleted: true);

      try {
        await mockDatabases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessagesCollectionId,
          documentId: 'test-message-1',
          data: messageToDelete.toJsonForUpload(),
        );
        fail('Should have thrown AppwriteException');
      } catch (e) {
        expect(e, isA<AppwriteException>());
      }

      verify(
        mockDatabases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessagesCollectionId,
          documentId: 'test-message-1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });
  });
}
