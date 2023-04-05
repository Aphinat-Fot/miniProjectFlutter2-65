// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String url;
  UserModel({
    required this.email,
    required this.name,
    required this.url,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? url,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'url': url,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      email: data['mail'],
      name: data['name'],
      url: data['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(email: $email, name: $name, url: $url)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email && other.name == name && other.url == url;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ url.hashCode;
}
