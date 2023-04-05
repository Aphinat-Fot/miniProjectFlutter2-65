// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NameModel {
  final String name;
  NameModel({
    required this.name,
  });

  NameModel copyWith({
    String? name,
  }) {
    return NameModel(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory NameModel.fromMap(Map<String, dynamic> map) {
    return NameModel(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NameModel.fromJson(String source) =>
      NameModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NameModel(name: $name)';

  @override
  bool operator ==(covariant NameModel other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
