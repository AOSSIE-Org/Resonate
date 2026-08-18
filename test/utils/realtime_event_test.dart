import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/utils/realtime_event.dart';

void main() {
  group('realtimeAction', () {
    const dualFormatCreate = [
      'databases.db.collections.tbl.documents.row1.create',
      'databases.db.tables.tbl.rows.row1.create',
      'databases.*.collections.*.documents.*.create',
      'databases.*.tables.*.rows.*.create',
      'databases.db.collections.tbl.documents.row1',
      'databases.db.tables.tbl.rows.row1',
    ];

    test('reads create from a dual-format event list (collections first)', () {
      expect(realtimeAction(dualFormatCreate), 'create');
    });

    test('reads update regardless of channel format or order', () {
      expect(
        realtimeAction([
          'databases.db.collections.tbl.documents.row1.update',
          'databases.db.tables.tbl.rows.row1.update',
        ]),
        'update',
      );
    });

    test('reads delete', () {
      expect(
        realtimeAction(['databases.db.tables.tbl.rows.row1.delete']),
        'delete',
      );
    });

    test('handles the single tables.rows event form', () {
      expect(
        realtimeAction(['databases.db.tables.tbl.rows.row1.create']),
        'create',
      );
    });

    test('returns empty string when no action suffix is present', () {
      expect(realtimeAction(['databases.db.tables.tbl.rows.row1']), '');
      expect(realtimeAction(const []), '');
    });
  });
}
