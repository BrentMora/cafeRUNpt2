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
      appBar: AppBar(
        title: const Text('Inventory'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: inventoryController.inventory.isEmpty
            ? const Center(
                child: Text(
                  'No inventory items available',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: inventoryController.inventory.length,
                itemBuilder: (context, index) {
                  final item = inventoryController.inventory[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(item.itemName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                              'Quantity: ${item.quantity} ${item.unit}  |  Cost: \$${item.cost.toStringAsFixed(2)}'),
                          const SizedBox(height: 4),
                          Text('Category: ${item.category}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              _showInventoryDialog(
                                  context, inventoryController,
                                  item: item);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await inventoryController.deleteItem(item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInventoryDialog(context, inventoryController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showInventoryDialog(
      BuildContext context, InventoryController controller,
      {InventoryTableData? item}) {
    final nameController = TextEditingController(text: item?.itemName ?? '');
    final qtyController =
        TextEditingController(text: item?.quantity.toString() ?? '');
    final unitController = TextEditingController(text: item?.unit ?? '');
    final costController =
        TextEditingController(text: item?.cost.toString() ?? '');
    final categoryController =
        TextEditingController(text: item?.category ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(item == null ? 'Add Inventory' : 'Edit Inventory'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: qtyController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unit')),
              TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: 'Cost'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category')),
            ],
          ),
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
