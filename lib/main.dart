import 'package:flutter/material.dart';
import 'app_database.dart';
import 'InventoryController.dart';
import 'OrderController.dart';
import 'inventory_view.dart';
import 'order_view.dart';
import 'modern_pos.dart';
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
        ChangeNotifierProvider(
            create: (_) => InventoryController(db)..loadInventory()),
        ChangeNotifierProvider(
            create: (_) => OrderController(db)..loadOrders()),
      ],
      child: MaterialApp(
        title: 'POS System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color color = Colors.blue}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: color.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          height: 120,
          child: Row(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(width: 20),
              Text(label,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS System'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMenuCard(
              context,
              icon: Icons.inventory_2,
              label: 'Manage Inventory',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const InventoryView()));
              },
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              icon: Icons.receipt_long,
              label: 'View Orders',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OrderView()));
              },
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              icon: Icons.point_of_sale,
              label: 'Modern POS',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ModernPOS()));
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
