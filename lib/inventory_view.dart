import 'package:flutter/material.dart';
import 'app_database.dart';
import 'InventoryController.dart';
import 'package:provider/provider.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventoryController = Provider.of<InventoryController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: inventoryController.inventory.length,
              itemBuilder: (context, index) {
                final item = inventoryController.inventory[index];
                return ListTile(
                  title: Text(item.itemName),
                  subtitle: Text('Qty: ${item.quantity}, Cost: \$${item.cost}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showInventoryDialog(context, inventoryController, item: item);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showInventoryDialog(context, inventoryController);
            },
            child: const Text('Add Inventory'),
          ),
        ],
      ),
    );
  }

  void _showInventoryDialog(BuildContext context, InventoryController controller,
      {InventoryTableData? item}) {
    final nameController = TextEditingController(text: item?.itemName ?? '');
    final qtyController = TextEditingController(text: item?.quantity.toString() ?? '');
    final unitController = TextEditingController(text: item?.unit ?? '');
    final costController = TextEditingController(text: item?.cost.toString() ?? '');
    final categoryController = TextEditingController(text: item?.category ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Add Inventory' : 'Edit Inventory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit')),
            TextField(controller: costController, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addOrUpdate(
                id: item?.id,
                itemName: nameController.text,
                quantity: int.tryParse(qtyController.text) ?? 0,
                unit: unitController.text,
                cost: double.tryParse(costController.text) ?? 0.0,
                category: categoryController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
