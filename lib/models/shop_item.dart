import 'dart:convert';

class ShopItem {
  final String id;
  final String name;
  final double price;
  final String billId;
  final List<String> payersIds;
  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.billId,
    required this.payersIds,
  });

  @override
  bool operator ==(covariant ShopItem other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'billId': billId,
      'payersIds': payersIds,
    };
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      billId: map['billId'] as String,
      payersIds: List<String>.from(map['payersIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopItem.fromJson(String source) => ShopItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
