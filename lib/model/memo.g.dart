// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memo _$MemoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['user_id', 'created_at', 'updated_at'],
  );
  return Memo(
    id: json['id'] as int,
    userId: json['user_id'] as int,
    title: json['title'] as String?,
    content: json['content'] as String?,
    password: json['password'] as String?,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$MemoToJson(Memo instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'password': instance.password,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
