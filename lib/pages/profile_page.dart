import 'package:chatify_app/pages/models/contact.dart';
import 'package:chatify_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatelessWidget {
  final double _height;
  final double _width;
  AuthProvider _auth;
  ProfilePage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _profilePageUI(),
      ),
    );
  }

  Widget _profilePageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return StreamBuilder<Contact>(
          stream: DBService.instance.getUserData(_auth.user.uid),
          builder: (_context, _snapshot) {
            var _userData = _snapshot.data;
            return _snapshot.hasData
                ? Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: _height * 0.50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _userImageWidget(_userData.image),
                          _userNameWidget(_userData.name),
                          _userEmailWidget(_userData.email),
                          _logOutButton(),
                        ],
                      ),
                    ),
                  )
                : SpinKitWanderingCubes(
                    color: Colors.blue,
                    size: 50.0,
                  );
          },
        );
      },
    );
  }

  Widget _userImageWidget(String _image) {
    double _imageRadius = _height * 0.25;
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        height: _imageRadius,
        width: _imageRadius,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(_imageRadius),
          image: DecorationImage(
            image: NetworkImage(_image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _userNameWidget(String _userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        _userName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _userEmailWidget(String _userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        _userName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white24,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _logOutButton() {
    return Container(
      height: _height * 0.08,
      width: _width * 0.8,
      child: MaterialButton(
        onPressed: () {
          _auth.logoutUser(() {});
        },
        child: Text(
          "LOGOUT",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        color: Colors.red,
      ),
    );
  }
}
