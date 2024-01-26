// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memo _$MemoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['user_id', 'written_at'],
  );
  return Memo(
    id: json['id'] as int,
    userId: json['user_id'] as int,
    content: json['content'] as String,
    writtenAt: json['written_at'] as String,
  );
}

Map<String, dynamic> _$MemoToJson(Memo instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'content': instance.content,
      'written_at': instance.writtenAt,
    };
