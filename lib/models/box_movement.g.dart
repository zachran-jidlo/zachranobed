// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxMovement _$BoxMovementFromJson(Map<String, dynamic> json) => BoxMovement(
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      boxType: json['boxType'] as String,
      numberOfBoxes: json['numberOfBoxes'] as int,
      weekNumber: json['weekNumber'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
    );

Map<String, dynamic> _$BoxMovementToJson(BoxMovement instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'boxType': instance.boxType,
      'numberOfBoxes': instance.numberOfBoxes,
      'weekNumber': instance.weekNumber,
      'date': const TimestampConverter().toJson(instance.date),
    };
