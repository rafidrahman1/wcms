import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('WasteItemRow')
class WasteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get memberId => text()();
  TextColumn get memberName => text().nullable()();
  RealColumn get weight => real()();
  TextColumn get type => text()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deletionThreshold =>
      integer().withDefault(const Constant(100))();
}

@DriftDatabase(tables: [WasteItems, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 6) {
        await migrator.deleteTable('waste_items');
        await migrator.createAll();
      } else if (from < 7) {
        await migrator.createTable(appSettings);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wms_database');
  }

  Stream<List<WasteItemRow>> watchAllWasteItems() {
    return (select(
      wasteItems,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<List<WasteItemRow>> getAllWasteItems() {
    return (select(
      wasteItems,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<WasteItemRow?> getWasteItemById(int id) {
    return (select(
      wasteItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertWasteItem(WasteItemsCompanion item) {
    return into(wasteItems).insert(item);
  }

  Future<int> countWasteItems() async {
    final count = countAll();
    final query = selectOnly(wasteItems)..addColumns([count]);
    final result = await query.map((row) => row.read(count)).getSingle();
    return result ?? 0;
  }

  Future<int> deleteWasteItem(int id) {
    return (delete(wasteItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllWasteItems() {
    return delete(wasteItems).go();
  }

  Future<int> getDeletionThreshold() async {
    final settings = await select(appSettings).getSingleOrNull();
    return settings?.deletionThreshold ?? 100;
  }

  Future<void> updateDeletionThreshold(int threshold) async {
    final settings = await select(appSettings).getSingleOrNull();
    if (settings == null) {
      await into(appSettings).insert(
        AppSettingsCompanion.insert(deletionThreshold: Value(threshold)),
      );
    } else {
      await (update(appSettings)..where((t) => t.id.equals(settings.id))).write(
        AppSettingsCompanion(deletionThreshold: Value(threshold)),
      );
    }
  }
}
