import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class InventoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemName => text()();
  IntColumn get quantity => integer()();
  TextColumn get unit => text()();
  RealColumn get cost => real()();
  DateTimeColumn get updateTimestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get updateTag => text().withDefault(const Constant('No Updates'))();
  TextColumn get category => text()();
}

class OrderTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().customConstraint('NOT NULL REFERENCES inventory_table(id)')();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [InventoryTable, OrderTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Inventory
  Future<int> insertInventory(InventoryTableCompanion entry) =>
      into(inventoryTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> updateInventory(int id, InventoryTableCompanion entry) =>
      (update(inventoryTable)..where((tbl) => tbl.id.equals(id))).write(entry);

  Future<List<InventoryTableData>> getAllInventory() => select(inventoryTable).get();

  // Orders
  Future<int> insertOrder(OrderTableCompanion entry) => into(orderTable).insert(entry);

  Future<void> deleteInventory(int id) async {
    await (delete(inventoryTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<OrderTableData>> getAllOrders() => select(orderTable).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print('Database folder: ${dbFolder.path}'); // <-- add this
    final file = File(p.join(dbFolder.path, 'pos_database.sqlite'));
    print('Database file: ${file.path}');       // <-- and this
    return NativeDatabase(file);
  });
}

