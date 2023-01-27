// ignore_for_file: depend_on_referenced_packages
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart';
import 'package:project_devscore/GitHub/core/infrastructure/dio_extensions.dart';
import 'package:project_devscore/GitHub/core/shared/encoders.dart';
import 'package:http/http.dart' as http;
import 'package:project_devscore/GitHub/github_auth/domain/auth_failure.dart';
import 'package:project_devscore/GitHub/github_auth/infrastructure/credentials_storage/credential_storage.dart';

class GithubOAuthHttpClient extends http.BaseClient {
  final httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return httpClient.send(request);
  }
}

class GithubAuthenticator {
  final CredentialsStorage _credentialsStorage;
  final Dio _dio;

  GithubAuthenticator(this._credentialsStorage, this._dio);

  // form github oauth app
  static const clientId = 'bfc0d0982a06ec297ee1';

  // not need hardcoded , need it at created time gonna change , should not make it public this secrets
  static const clientSecret = '00e7feffa65badec571ee77063b9130bf12eeeb9';

  // access token
  static const scopes = ['read:user', 'repo'];

  static final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');

  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');

  // we are going to use dio , dio is more advanced http client
  static final revocationEndpoint =
      Uri.parse('http://api.github.com/applications/$clientId/token');

// on mobile it doesn't matter it can be anything
  static final redirectUrl = Uri.parse('http://localhost:3000/callback');

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();
      if (storedCredentials != null) {
        if (storedCredentials.canRefresh && storedCredentials.isExpired) {
          // never gonna happen here cause we are dealing with github
          final failureOrCredentials = await refresh(storedCredentials);
          return failureOrCredentials.fold((l) => null, (r) => r);
        }
      }
      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
      clientId,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
      httpClient: GithubOAuthHttpClient(),
    );
  }

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
  }

  // unit can be used to return void , so this function returns anything
  Future<Either<AuthFailure, Unit>> handleAuthroizationResponse(
    AuthorizationCodeGrant grant,
    Map<String, String> queryParams,
  ) async {
    try {
      // return type is HTTP client here , but we want access token
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      // so getting that and we are using credentials and storing them to get access
      await _credentialsStorage.save(httpClient.credentials);
      // we only return this when the right side of the either is unit
      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  // to signout from github
  Future<Either<AuthFailure, Unit>> signOutGitHub() async {
    final accessToken = await _credentialsStorage
        .read()
        .then((credentials) => credentials?.accessToken);

    final usernameAndPassword =
        stringToBase64.encode('$clientId:$clientSecret');
    try {
      try {
        _dio.deleteUri(
          revocationEndpoint,
          data: {
            'access_token': accessToken,
          },
          options: Options(
            headers: {
              'Authorization': 'basic $usernameAndPassword',
            },
          ),
        );
        // socketException - for less internet connection
      } on DioError catch (e) {
        if (e.isNoConnection) {
          // do nothing
        } else {
          rethrow;
        }
      }
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Credentials>> refresh(
    Credentials credentials,
  ) async {
    try {
      final refreshCredentials = await credentials.refresh(
        identifier: clientId,
        secret: clientSecret,
        httpClient: GithubOAuthHttpClient(),
      );
      await _credentialsStorage.save(refreshCredentials);
      return right(refreshCredentials);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}:${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
