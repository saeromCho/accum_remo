import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  // id INTEGER PRIMARY KEY,
  // password TEXT NOT NULL,
  // nick_name TEXT NOT NULL UNIQUE,
  // shorten_introducing TEXT,
  // created_at DATETIME NOT NULL,
  // updated_at DATETIME NOT NULL

  final int id;
  final String password;
  @JsonKey(disallowNullValue: true, name: 'nick_name')
  final String nickName;
  @JsonKey(disallowNullValue: false, name: 'shorten_introducing')
  final String? shortenIntroducing;
  @JsonKey(disallowNullValue: true, name: 'created_at')
  final String createdAt;
  @JsonKey(disallowNullValue: true, name: 'updated_at')
  final String updatedAt;

  User({
    required this.id,
    required this.password,
    required this.nickName,
    this.shortenIntroducing,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
