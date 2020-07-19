import 'dart:io';

import 'package:chatify_app/models/contact.dart';
import 'package:chatify_app/providers/auth_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  final double _height;
  final double _width;

  ProfilePage(this._height, this._width);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthProvider _auth;
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      color: Theme.of(context).backgroundColor,
      height: widget._height,
      width: widget._width,
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
                      height: widget._height * 0.50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _userImageWidget(_userData.image, _userData.id),
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

  Widget _userImageWidget(String _image, String _uid) {
    double _imageRadius = widget._height * 0.25;
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () async {
            File _imagefile = await MediaService.instance.getImageFromLibrary();
            if (_imagefile != null) {
              var result = await CloudStorageService.instance
                  .uploadUserImage(_uid, _imagefile);
              var _imageURL = await result.ref.getDownloadURL();
              await DBService.instance.updateImage(_uid, _imageURL);
              setState(() {
                _imageFile = _imagefile;
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            height: _imageRadius,
            width: _imageRadius,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(_imageRadius),
              image: DecorationImage(
                image: _imageFile != null
                    ? FileImage(_imageFile)
                    : NetworkImage(_image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userNameWidget(String _userName) {
    return Container(
      height: widget._height * 0.05,
      width: widget._width,
      child: Text(
        _userName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _userEmailWidget(String _userName) {
    return Container(
      height: widget._height * 0.05,
      width: widget._width,
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
      height: widget._height * 0.08,
      width: widget._width * 0.8,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: Colors.red)),
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
