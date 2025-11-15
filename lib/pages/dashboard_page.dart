import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import '../widgets/item_dialog.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Item> _items = [];
  final ApiService _api = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _api.fetchItems();
      setState(() => _items.clear());
      setState(() => _items.addAll(items));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showItemDialog({Item? item, int? index}) async {
    final result = await showDialog<Item>(
      context: context,
      builder: (_) => ItemDialog(item: item),
    );

    if (result != null) {
      try {
        if (index != null) {
          // existing item -> update
          final updated = await _api.updateItem(result);
          setState(() => _items[index] = updated);
        } else {
          // new item -> create
          final created = await _api.createItem(result.name, result.price);
          setState(() => _items.add(created));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
      }
    }
  }

  void _deleteItem(int index) async {
    final id = _items[index].id;
    if (id == null) {
      setState(() => _items.removeAt(index));
      return;
    }
    try {
      await _api.deleteItem(id);
      setState(() => _items.removeAt(index));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Barang'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF6A11CB),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (_, i) => ItemCard(
                item: _items[i],
                onEdit: () => _showItemDialog(item: _items[i], index: i),
                onDelete: () => _deleteItem(i),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF6A11CB),
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
