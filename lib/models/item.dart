class Item {
  final String name;
  final int price;

  Item({required this.name, required this.price});

  Item copyWith({String? name, int? price}) {
    return Item(name: name ?? this.name, price: price ?? this.price);
  }
}
