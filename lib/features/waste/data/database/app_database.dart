import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('WasteItemRow')
class WasteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get memberId => text()();
  RealColumn get weight => real()();
  TextColumn get type => text()();
  TextColumn get imagePath => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [WasteItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 4) {
            await migrator.deleteTable('waste_items');
            await migrator.createAll();
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wms_database');
  }

  Stream<List<WasteItemRow>> watchAllWasteItems() {
    return (select(wasteItems)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<WasteItemRow>> getAllWasteItems() {
    return (select(wasteItems)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<WasteItemRow?> getWasteItemById(int id) {
    return (select(wasteItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertWasteItem(WasteItemsCompanion item) {
    return into(wasteItems).insert(item);
  }

  Future<int> deleteWasteItem(int id) {
    return (delete(wasteItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllWasteItems() {
    return delete(wasteItems).go();
  }
}
