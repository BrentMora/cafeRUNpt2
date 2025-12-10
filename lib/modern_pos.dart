import 'package:flutter/material.dart';
import 'OrderController.dart';
import 'package:provider/provider.dart';

// Dummy menu
final List<Map<String, dynamic>> dummyMenu = [
  {'id': 1, 'name': 'Espresso', 'price': 150.0},
  {'id': 2, 'name': 'Cappuccino', 'price': 170.0},
];

class ModernPOS extends StatefulWidget {
  const ModernPOS({Key? key}) : super(key: key);

  @override
  _ModernPOSState createState() => _ModernPOSState();
}

class _ModernPOSState extends State<ModernPOS> {
  final Map<int, int> cart = {}; // menu item id -> quantity

  double get total {
    double sum = 0;
    for (var entry in cart.entries) {
      final item = dummyMenu.firstWhere((i) => i['id'] == entry.key);
      sum += item['price'] * entry.value;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<OrderController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('POS - Dummy Menu')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dummyMenu.length,
              itemBuilder: (context, index) {
                final item = dummyMenu[index];
                final qty = cart[item['id']] ?? 0;
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text('\$${item['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: qty > 0
                              ? () =>
                                  setState(() => cart[item['id']] = qty - 1)
                              : null,
                        ),
                        Text(qty.toString(), style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              setState(() => cart[item['id']] = qty + 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: cart.values.any((qty) => qty > 0)
                      ? () async {
                          // Insert each item instance separately
                          for (var entry in cart.entries) {
                            final item = dummyMenu
                                .firstWhere((i) => i['id'] == entry.key);
                            for (int i = 0; i < entry.value; i++) {
                              await orderController.addOrder(
                                itemId: entry.key,
                                quantity: 1,
                                unitPrice: item['price'],
                              );
                            }
                          }
                          setState(() {
                            cart.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order confirmed!')),
                          );
                        }
                      : null,
                  child: const Text('Confirm Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
