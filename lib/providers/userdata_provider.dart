import 'package:flutter/cupertino.dart';
import 'package:project_devscore/model/user_model.dart';
import 'package:project_devscore/services/auth_methods.dart';

class UserDataProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUserData => _user!;

  Future<void> refreshUserData() async {
    User user = await _authMethods.getUserData();
    _user = user;
    notifyListeners();
  }
}
