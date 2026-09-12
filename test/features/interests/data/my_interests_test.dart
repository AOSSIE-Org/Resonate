import 'package:appwrite/models.dart' show Row;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/data/my_interests.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB tables;

  Row row(Object? interests) => buildRow(
    id: 'me',
    tableId: usersTableID,
    databaseId: userDatabaseID,
    data: {'interests': interests},
  );

  void stubStored(Object? interests) {
    when(
      tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => row(interests));
  }

  ProviderContainer makeContainer({bool signedIn = true}) {
    final container = ProviderContainer(
      overrides: [
        appwriteTablesProvider.overrideWithValue(tables),
        currentUserProvider.overrideWithValue(
          signedIn ? fakeAuthUser(uid: 'me') : null,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  List<Object?> writtenInterests() =>
      verify(
            tables.updateRow(
              databaseId: userDatabaseID,
              tableId: usersTableID,
              rowId: 'me',
              data: captureAnyNamed('data'),
            ),
          ).captured
          .map((data) => (data as Map)['interests'])
          .toList();

  setUp(() {
    tables = MockTablesDB();
    stubStored(['music']);
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => row(['music']));
  });

  test('hydrates from the signed-in user row', () async {
    final container = makeContainer();

    expect(await container.read(myInterestsProvider.future), [Interest.music]);
  });

  test('is empty with no signed-in user and reads nothing', () async {
    final container = makeContainer(signedIn: false);

    expect(await container.read(myInterestsProvider.future), isEmpty);
    verifyNever(
      tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ),
    );
  });

  test('a failed read is no interests, not an error state', () async {
    when(
      tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ),
    ).thenThrow(Exception('offline'));
    final container = makeContainer();

    expect(await container.read(myInterestsProvider.future), isEmpty);
    expect(container.read(myInterestsProvider).hasError, isFalse);
  });

  group('save', () {
    test('writes the selection and publishes it', () async {
      final container = makeContainer();
      await container.read(myInterestsProvider.future);

      final saved = await container
          .read(myInterestsProvider.notifier)
          .save([Interest.ai, Interest.books]);

      expect(saved, isTrue);
      expect(writtenInterests(), [
        ['ai', 'books'],
      ]);
      expect(container.read(myInterestsProvider).value, [
        Interest.ai,
        Interest.books,
      ]);
    });

    test('caps the write at the selectable maximum', () async {
      final container = makeContainer();
      await container.read(myInterestsProvider.future);

      await container
          .read(myInterestsProvider.notifier)
          .save(Interest.values.toList());

      expect(
        writtenInterests().single,
        hasLength(Interest.maxSelectable),
      );
    });

    test('reports failure and leaves the published value alone', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(Exception('nope'));
      final container = makeContainer();
      await container.read(myInterestsProvider.future);

      final saved = await container
          .read(myInterestsProvider.notifier)
          .save([Interest.ai]);

      expect(saved, isFalse);
      expect(container.read(myInterestsProvider).value, [Interest.music]);
    });

    test('does nothing without a signed-in user', () async {
      final container = makeContainer(signedIn: false);
      await container.read(myInterestsProvider.future);

      expect(
        await container.read(myInterestsProvider.notifier).save([Interest.ai]),
        isFalse,
      );
      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });
  });
}
