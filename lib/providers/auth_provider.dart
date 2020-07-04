import 'package:chatify_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/snackbar_service.dart';
import '../services/navigation_service.dart';

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
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() {
    if (user != null) {
      NavigationService.instance.navigateToReplacement("home");
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser();
    if (user != null) {
      notifyListeners();
      _autoLogin();
    }
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
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      print("Login Error");
      SnackBarService.instance.showSnackBarError("Error");
      //display an error
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;

      await onSuccess(user.uid);

      SnackBarService.instance.showSnackBarSuccess("Welcome ${user.email}");
      //Update last seen time
      NavigationService.instance.goBack();
      //Navigation to HomePage
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      print("Register Error");
      SnackBarService.instance.showSnackBarError("Error Registing User");
    }
    notifyListeners();
  }

  void logoutUser(Future<void> onSuccess()) async {
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement("login");
      SnackBarService.instance.showSnackBarSuccess("Logged out Successfully");
    } catch (e) {
      SnackBarService.instance.showSnackBarSuccess("Error Logged out ");
    }
    notifyListeners();
  }
}
