import 'package:flutter/material.dart';
import 'app_database.dart';
import 'package:drift/drift.dart';

class InventoryController extends ChangeNotifier {
  final AppDatabase db;

  InventoryController(this.db);

  List<InventoryTableData> _inventory = [];
  List<InventoryTableData> get inventory => _inventory;

  Future<void> loadInventory() async {
    _inventory = await db.getAllInventory();  // database operation called
    notifyListeners();
  }

  Future<void> addOrUpdate({
    int? id,
    required String itemName,
    required int quantity,
    required String unit,
    required double cost,
    required String category,
  }) async {
    final entry = InventoryTableCompanion(
      itemName: Value(itemName),
      quantity: Value(quantity),
      unit: Value(unit),
      cost: Value(cost),
      category: Value(category),
      updateTimestamp: Value(DateTime.now()),
      updateTag: Value('Updated'),
    );

    if (id == null) {
      await db.insertInventory(entry);  // database operation called
    } else {
      await db.updateInventory(id, entry);  // database operation called
    }

    await loadInventory();
  }

  /// Deletes an inventory item by id
  Future<void> deleteItem(int id) async {
    await db.deleteInventory(id);    // database operation called
    await loadInventory();
  }
}
