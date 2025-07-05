import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

@freezed
class SignupRequest with _$SignupRequest {
  factory SignupRequest({
    required String username,
    required String email,
    required String password,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
