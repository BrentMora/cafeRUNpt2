import 'package:flutter/material.dart';
import 'app_database.dart';
import 'InventoryController.dart';
import 'OrderController.dart';
import 'inventory_view.dart';
import 'order_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({required this.db, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryController(db)..loadInventory()),
        ChangeNotifierProvider(create: (_) => OrderController(db)..loadOrders()),
      ],
      child: MaterialApp(
        title: 'POS System',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS System')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const InventoryView()));
                },
                child: const Text('Manage Inventory')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const OrderView()));
                },
                child: const Text('Manage Orders')),
          ],
        ),
      ),
    );
  }
}
