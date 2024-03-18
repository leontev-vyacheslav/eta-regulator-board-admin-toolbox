import 'package:json_annotation/json_annotation.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  String token;
  String login;

  AuthUserModel({required this.token, required this.login});

  // Connect the generated [_$AuthUserModelJson] function to the `fromJson`
  /// factory.
  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);

  /// Connect the generated [_$AuthUserModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);
}
