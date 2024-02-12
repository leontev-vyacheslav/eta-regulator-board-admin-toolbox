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

  // static Future initAsync () async {
  //   List<RegulatorDeviceModel> devices = [
  //     RegulatorDeviceModel(
  //         id: '3c23980d-7e47-4ce5-97ff-8a236a1411f3',
  //         name: 'omega-8f79',
  //         macAddress: '40:a3:6b:c9:8f:7a',
  //         masterKey: 'XAMhI3XWj+PaXP5nRQ+nNpEn9DKyHPTVa95i89UZL6o='),
  //     RegulatorDeviceModel(
  //         id: '6aa2c3e5-5ff3-41b9-a3b2-476d645d3566',
  //         name: 'Omega-8f79-devcontainer',
  //         macAddress: '02:42:ac:11:00:02',
  //         masterKey: 'XAMhI3XWj+PaXP5nRQ+nNpEn9DKyHPTVa95i89UZL6o=')
  //   ];

  //   String jsonText = jsonEncode(devices);

  //   await App.localStorage?.setString('devices', jsonText);
  // }
}
