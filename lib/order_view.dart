import 'package:flutter/material.dart';
import 'app_database.dart';
import 'OrderController.dart';
import 'InventoryController.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<OrderController>(context);
    final inventoryController = Provider.of<InventoryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: orderController.orders.isEmpty
            ? const Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];
                  final item = inventoryController.inventory.firstWhere(
                    (i) => i.id == order.itemId,
                    orElse: () => InventoryTableData(
                      id: 0,
                      itemName: 'Deleted',
                      quantity: 0,
                      unit: '',
                      cost: 0,
                      updateTimestamp: DateTime.now(),
                      updateTag: '',
                      category: '',
                    ),
                  );

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(item.itemName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Qty: ${order.quantity}  |  Unit Price: \$${order.unitPrice.toStringAsFixed(2)}  |  Total: \$${(order.quantity * order.unitPrice).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      tileColor: Colors.blue.shade50,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
