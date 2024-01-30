import 'package:json_annotation/json_annotation.dart';

part 'memo.g.dart';

@JsonSerializable()
class Memo {
  // id INTEGER PRIMARY KEY,
  // user_id INTEGER NOT NULL,
  // title TEXT,
  // content TEXT,
  // password TEXT,
  // is_private INTEGER NOT NULL,
  // created_at DATETIME NOT NULL,
  // updated_at DATETIME NOT NULL,
  // FOREIGN KEY(user_id) REFERENCES User(id))

  final int? id;
  @JsonKey(disallowNullValue: true, name: 'user_id')
  final int userId;

  final String? title;
  final String? content;
  final String? password;
  @JsonKey(disallowNullValue: true, name: 'is_private')
  final int isPrivate;
  @JsonKey(disallowNullValue: true, name: 'created_at')
  final String createdAt;
  @JsonKey(disallowNullValue: true, name: 'updated_at')
  final String updatedAt;

  Memo({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.password,
    this.isPrivate = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Memo.fromJson(Map<String, dynamic> json) => _$MemoFromJson(json);

  Map<String, dynamic> toJson() => _$MemoToJson(this);
}
