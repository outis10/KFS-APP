import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

/// Key-value metadata (e.g. last catalog sync). Feature tables are added
/// by their features (M4 #16) with explicit migrations.
class AppMeta extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Local SQLite database: single source of truth for the UI (offline-first).
@DriftDatabase(tables: [AppMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'kfs'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Add `onUpgrade` steps with tests for every schema version bump.
  );

  Future<String?> readMeta(String key) async {
    final row = await (select(
      appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> writeMeta(String key, String value) => into(appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
