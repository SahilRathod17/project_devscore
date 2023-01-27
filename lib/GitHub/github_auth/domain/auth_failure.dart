import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub  run build_runner watch --delete-conflicting-outputs

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const AuthFailure._();
  const factory AuthFailure.server([String? message]) = _Server;
  const factory AuthFailure.storage() = _Storage;
}
