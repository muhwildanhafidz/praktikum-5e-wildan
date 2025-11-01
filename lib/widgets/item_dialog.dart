import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemDialog extends StatefulWidget {
  final Item? item;
  const ItemDialog({super.key, this.item});

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController priceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    priceCtrl = TextEditingController(
      text: widget.item?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.item == null ? 'Tambah Barang' : 'Edit Barang'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Barang'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Harga'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A11CB),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final name = nameCtrl.text.trim();
            final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
            if (name.isEmpty || price <= 0) return;
            Navigator.pop(context, Item(name: name, price: price));
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
