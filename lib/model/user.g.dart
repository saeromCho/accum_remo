// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['nick_name', 'created_at', 'updated_at'],
  );
  return User(
    id: json['id'] as int,
    password: json['password'] as String,
    nickName: json['nick_name'] as String,
    shortenIntroducing: json['shorten_introducing'] as String?,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'nick_name': instance.nickName,
      'shorten_introducing': instance.shortenIntroducing,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
