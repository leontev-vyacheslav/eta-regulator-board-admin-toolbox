import 'package:json_annotation/json_annotation.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel {
  String login;

  String password;

  SignInModel({required this.login, required this.password});

  // Connect the generated [_$SignInFromJson] function to the `fromJson`
  /// factory.
  factory SignInModel.fromJson(Map<String, dynamic> json) => _$SignInModelFromJson(json);

  /// Connect the generated [_$SignInModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SignInModelToJson(this);
}
