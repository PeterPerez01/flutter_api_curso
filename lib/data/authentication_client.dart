import 'dart:async';
import 'dart:convert';

import 'package:api_application/Api/authentication_api.dart';
import 'package:api_application/models/authentication_response.dart';
import 'package:api_application/models/session.dart';
import 'package:api_application/utils/logs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationClient {
  final FlutterSecureStorage _secureStorage;
  final AuthenticationAPI _authenticationAPI;

  Completer? _completer;

  AuthenticationClient(this._secureStorage, this._authenticationAPI);

  void _complete() {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete();
    }
  }

  Future<String?> get accessToken async {
    if (_completer != null) {
      await _completer!.future;
    }
    Logs.p.i("called ${DateTime.now()}");
    _completer = Completer();

    final data = await _secureStorage.read(key: 'SESSION');
    if (data != null) {
      final session = Session.fromJson(jsonDecode(data));

      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDate.difference(createdAt).inSeconds;
      Logs.p.i("session life time ${expiresIn - diff}");

      if (expiresIn - diff >= 60) {
        _complete();
        return session.token;
      }

      final response = await _authenticationAPI.refreshToken(
        expiredToken: session.token,
      );
      if (response.data != null) {
        await saveSession(response.data!);
        _complete();
        return response.data!.token;
      }
      _complete();
      return null;
    }
    _complete();
    return null;
  }

  Future<void> saveSession(
      AuthenticationResponse authenticationResponse) async {
    final Session session = Session(
      token: authenticationResponse.token,
      expiresIn: authenticationResponse.expiresIn,
      createdAt: DateTime.now(),
    );
    final data = jsonEncode(session.toJson());
    await _secureStorage.write(
      key: 'SESSION',
      value: data,
    );
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }
}
