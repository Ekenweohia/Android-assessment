import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required String id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String image,        
    required String accessToken,
    required String refreshToken,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
