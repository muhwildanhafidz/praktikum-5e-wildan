import 'dart:convert';

class Item {
  final int? id;
  final String name;
  final String price;
  final String? createdAt;
  final String? updatedAt;

  Item({
    this.id,
    required this.name,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  Item copyWith({
    int? id,
    String? name,
    String? price,
    String? createdAt,
    String? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id_barang'] is int
          ? json['id_barang']
          : int.tryParse('${json['id_barang']}'),
      name: json['nama'] ?? json['name'] ?? '',
      // Harga disimpan sebagai string agar kompatibel dengan tipe DECIMAL di MySQL
      price: json['harga'] != null ? json['harga'].toString() : '0',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_barang': id,
      'nama': name,
      // Kirim harga sebagai string untuk mempertahankan presisi desimal
      'harga': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
