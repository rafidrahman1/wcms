import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/waste/data/database/app_database.dart';
import 'package:wms/features/waste/data/repositories/waste_repository_impl.dart';
import 'package:wms/features/waste/domain/entities/waste_item.dart';
import 'package:wms/features/waste/domain/repositories/waste_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final wasteRepositoryProvider = Provider<WasteRepository>((ref) {
  return WasteRepositoryImpl(ref.watch(databaseProvider));
});

final wasteItemsStreamProvider = StreamProvider<List<WasteItem>>((ref) {
  return ref.watch(wasteRepositoryProvider).watchAll();
});

final wasteItemByIdProvider =
    FutureProvider.family<WasteItem?, int>((ref, id) async {
  return ref.watch(wasteRepositoryProvider).getById(id);
});
