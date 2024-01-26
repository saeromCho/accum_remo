import 'package:json_annotation/json_annotation.dart';

part 'memo.g.dart';

@JsonSerializable()
class Memo {
  final int id;
  @JsonKey(disallowNullValue: true, name: 'user_id')
  final int userId;
  final String content;
  @JsonKey(disallowNullValue: true, name: 'written_at')
  final String writtenAt;

  Memo(
      {required this.id,
      required this.userId,
      required this.content,
      required this.writtenAt});

  factory Memo.fromJson(Map<String, dynamic> json) => _$MemoFromJson(json);

  Map<String, dynamic> toJson() => _$MemoToJson(this);
}
