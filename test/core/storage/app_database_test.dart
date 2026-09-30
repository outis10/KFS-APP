import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/storage/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('writeMeta upserts and readMeta returns the latest value', () async {
    expect(await db.readMeta('catalogVersion'), isNull);

    await db.writeMeta('catalogVersion', '2026-10-01.1');
    await db.writeMeta('catalogVersion', '2026-10-02.1');

    expect(await db.readMeta('catalogVersion'), '2026-10-02.1');
  });
}
