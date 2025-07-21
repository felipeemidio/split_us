import 'dart:convert';

class Bill {
  final String id;
  final String name;
  final List<String> membersIds;
  final DateTime createdAt;

  const Bill({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.membersIds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'membersIds': membersIds,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      membersIds: List<String>.from(map['membersIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Bill other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
