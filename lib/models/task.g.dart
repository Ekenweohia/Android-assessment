// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: (json['id'] as num).toInt(),
  title: json['todo'] as String,
  completed: json['completed'] as bool,
  userId: (json['userId'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool?,
  deletedOn: json['deletedOn'] == null
      ? null
      : DateTime.parse(json['deletedOn'] as String),
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'todo': instance.title,
      'completed': instance.completed,
      'userId': instance.userId,
      'isDeleted': instance.isDeleted,
      'deletedOn': instance.deletedOn?.toIso8601String(),
    };
