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
      appBar: AppBar(title: const Text('Orders')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                        ));
                return ListTile(
                  title: Text(item.itemName),
                  subtitle: Text(
                      'Qty: ${order.quantity}, Unit Price: \$${order.unitPrice}, Total: \$${(order.quantity * order.unitPrice).toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showOrderDialog(context, orderController, inventoryController);
            },
            child: const Text('Add Order'),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(BuildContext context, OrderController orderController,
      InventoryController inventoryController) async {
    final inventoryItems = await orderController.getInventoryItems();
    InventoryTableData? selectedItem = inventoryItems.isNotEmpty ? inventoryItems[0] : null;
    final qtyController = TextEditingController();
    final priceController = TextEditingController(text: selectedItem?.cost.toString() ?? '0');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<InventoryTableData>(
              isExpanded: true,
              value: selectedItem,
              items: inventoryItems
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.itemName),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedItem = value;
                priceController.text = value?.cost.toString() ?? '0';
              },
            ),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (selectedItem != null) {
                await orderController.addOrder(
                  itemId: selectedItem!.id,
                  quantity: int.tryParse(qtyController.text) ?? 0,
                  unitPrice: double.tryParse(priceController.text) ?? 0,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
