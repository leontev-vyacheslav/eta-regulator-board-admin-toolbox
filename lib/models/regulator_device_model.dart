// import 'dart:convert';

// import 'package:flutter_test_app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'regulator_device_model.g.dart';

@JsonSerializable()
class RegulatorDeviceModel {
  String id;
  String name;
  String macAddress;
  String masterKey;

  RegulatorDeviceModel({required this.id, required this.name, required this.macAddress, required this.masterKey});

  factory RegulatorDeviceModel.fromJson(Map<String, dynamic> json) => _$RegulatorDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegulatorDeviceModelToJson(this);

}
