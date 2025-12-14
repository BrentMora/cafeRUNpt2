import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// InventoryTable extends the Table class from the drift package.
// The table class is used to define relations.
// Within the class, the attributes are defined
// line-by-line with the following syntax:
// <DataType>Column get <attribute name> => <function>

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

// OrderTable extends the Table class from the drift package.
// The table class is used to define relations.
// Within the class, the attributes are defined
// line-by-line with the following syntax:
// <DataType>Column get <attribute name> => <function>

class OrderTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().customConstraint('NOT NULL REFERENCES inventory_table(id)')();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

// @DriftDatabase and the AppDatabase class also comes from
// the drift package. Within this class, database operations
// are defined as class methods via Dart code.

@DriftDatabase(tables: [InventoryTable, OrderTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ======================
  // Inventory
  // ======================

  Future<int> insertInventory(InventoryTableCompanion entry) {
    return transaction(() async {
      return await into(inventoryTable)
          .insert(entry, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> updateInventory(int id, InventoryTableCompanion entry) {
    return transaction(() async {
      return await (update(inventoryTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(entry);
    });
  }

  Future<void> deleteInventory(int id) {
    return transaction(() async {
      await (delete(inventoryTable)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
    });
  }

  Future<List<InventoryTableData>> getAllInventory() {
    return transaction(() async {
      return await select(inventoryTable).get();
    });
  }

  // ======================
  // Orders
  // ======================

  Future<int> insertOrder(OrderTableCompanion entry) {
    return transaction(() async {
      return await into(orderTable).insert(entry);
    });
  }

  Future<List<OrderTableData>> getAllOrders() {
    return transaction(() async {
      return await select(orderTable).get();
    });
  }
}

// the LazyDatabase class allows the program to
// create a .sqlite file on the local computer
// containing the databases.

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print('Database folder: ${dbFolder.path}'); // <-- add this
    final file = File(p.join(dbFolder.path, 'pos_database.sqlite'));
    print('Database file: ${file.path}');       // <-- and this
    return NativeDatabase(file);
  });
}

