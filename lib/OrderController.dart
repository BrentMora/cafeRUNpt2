import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'app_database.dart';

class OrderController extends ChangeNotifier {
  final AppDatabase db;

  OrderController(this.db);

  List<OrderTableData> _orders = [];
  List<OrderTableData> get orders => _orders;

  Future<void> loadOrders() async {
    _orders = await db.getAllOrders();
    notifyListeners();
  }

  Future<void> addOrder({
    required int itemId,
    required int quantity,
    required double unitPrice,
  }) async {
    final entry = OrderTableCompanion(
      itemId: Value(itemId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      timestamp: Value(DateTime.now()),
    );

    await db.insertOrder(entry);
    await loadOrders();
  }

  // Fetch inventory for item selection
  Future<List<InventoryTableData>> getInventoryItems() => db.getAllInventory();
}
