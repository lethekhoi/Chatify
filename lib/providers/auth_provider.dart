import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/snackbar_service.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  static AuthProvider instance = AuthProvider();
  FirebaseUser user;
  AuthStatus status;

  FirebaseAuth _auth;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  void loginUserWithEmailandPassWord(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);

      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSnackBarSuccess("Welcome ${user.email}");
      print("Login In Successfullys");
      //navigation to home page
    } catch (e) {
      status = AuthStatus.Error;
      print("Login Error");
      SnackBarService.instance.showSnackBarError("Error");
      //display an error
    }
    notifyListeners();
  }
}
