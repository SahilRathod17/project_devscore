import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_devscore/GitHub/github_auth/application/auth_notifire.dart';
import 'package:project_devscore/GitHub/github_auth/infrastructure/credentials_storage/credential_storage.dart';
import 'package:project_devscore/GitHub/github_auth/infrastructure/github_authenticator.dart';
import 'package:riverpod/riverpod.dart';

import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

final flutterSecureStorageProvider =
    Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider(
  (ref) => Dio(),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => SecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final GithubAuthenticatorProvider = Provider(
  (ref) => GithubAuthenticator(
    ref.watch(credentialsStorageProvider),
    ref.watch(dioProvider),
  ),
);

final AuthNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(GithubAuthenticatorProvider)),
);
