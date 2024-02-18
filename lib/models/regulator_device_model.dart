// import 'dart:convert';

// import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'regulator_device_model.g.dart';

@JsonSerializable()
class RegulatorDeviceModel {
  String id;
  String name;
  String macAddress;
  String masterKey;
  String creationDate;

  RegulatorDeviceModel({required this.id, required this.name, required this.macAddress, required this.masterKey, required this.creationDate});

  factory RegulatorDeviceModel.fromJson(Map<String, dynamic> json) => _$RegulatorDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegulatorDeviceModelToJson(this);
}
