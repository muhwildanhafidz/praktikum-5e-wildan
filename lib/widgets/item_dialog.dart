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
    priceCtrl = TextEditingController(text: widget.item?.price ?? '');
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            final priceStr = priceCtrl.text.trim();
            // Validate numeric and positive value
            final priceDouble =
                double.tryParse(priceStr.replaceAll(',', '.')) ?? 0.0;
            if (name.isEmpty || priceDouble <= 0) return;
            final id = widget.item?.id;
            Navigator.pop(context, Item(id: id, name: name, price: priceStr));
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
