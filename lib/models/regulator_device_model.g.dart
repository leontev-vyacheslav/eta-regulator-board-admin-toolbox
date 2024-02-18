// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulator_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegulatorDeviceModel _$RegulatorDeviceModelFromJson(Map<String, dynamic> json) => RegulatorDeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      macAddress: json['macAddress'] as String,
      masterKey: json['masterKey'] as String,
      creationDate: json['creationDate'] as String,
    );

Map<String, dynamic> _$RegulatorDeviceModelToJson(RegulatorDeviceModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'macAddress': instance.macAddress,
      'masterKey': instance.masterKey,
      'creationDate': instance.creationDate,
    };
