// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UrlModel {
  final String url;
  UrlModel({
    required this.url,
  });

  UrlModel copyWith({
    String? url,
  }) {
    return UrlModel(
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
    };
  }

  factory UrlModel.fromMap(Map<String, dynamic> map) {
    return UrlModel(
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UrlModel.fromJson(String source) =>
      UrlModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UrlModel(url: $url)';

  @override
  bool operator ==(covariant UrlModel other) {
    if (identical(this, other)) return true;

    return other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
