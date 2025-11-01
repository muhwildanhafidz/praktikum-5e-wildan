import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import '../widgets/item_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Item> _items = [
    Item(name: 'Laptop', price: 15000000),
    Item(name: 'Smartphone', price: 8000000),
    Item(name: 'Headset', price: 500000),
  ];

  void _showItemDialog({Item? item, int? index}) async {
    final result = await showDialog<Item>(
      context: context,
      builder: (_) => ItemDialog(item: item),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _items[index] = result;
        } else {
          _items.add(result);
        }
      });
    }
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Barang'),
        backgroundColor: const Color(0xFF6A11CB),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (_, i) => ItemCard(
          item: _items[i],
          onEdit: () => _showItemDialog(item: _items[i], index: i),
          onDelete: () => _deleteItem(i),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A11CB),
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
