import 'package:chatify_app/models/contact.dart';
import 'package:chatify_app/providers/auth_provider.dart';
import '../services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchPage extends StatefulWidget {
  final double _height;
  final double _width;
  SearchPage(this._height, this._width);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText;
  AuthProvider _auth;
  _SearchPageState() {
    _searchText = '';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: _searchPageUI(),
    );
  }

  Widget _searchPageUI() {
    return Builder(builder: (BuildContext _context) {
      _auth = Provider.of<AuthProvider>(_context);
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _userSearchField(),
            _userListView(),
          ],
        ),
      );
    });
  }

  Widget _userSearchField() {
    return Container(
      height: widget._height * 0.08,
      width: widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * 0.02),
      child: TextField(
        autocorrect: false,
        onSubmitted: (_input) {
          setState(() {
            _searchText = _input;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _userListView() {
    return StreamBuilder<List<Contact>>(
        stream: DBService.instance.getUserInDB(_searchText),
        builder: (_context, _snapshot) {
          var _usersData = _snapshot.data;
          if (_usersData != null) {
            _usersData.removeWhere((_contact) => _contact.id == _auth.user.uid);
          }
          return _snapshot.hasData
              ? Container(
                  height: widget._height * 0.7,
                  width: widget._width,
                  child: ListView.builder(
                      itemCount: _usersData.length,
                      itemBuilder: (_context, _index) {
                        var _userData = _usersData[_index];
                        var _currentTime = DateTime.now();
                        var _isUserActive =
                            !_userData.lastseen.toDate().isBefore(
                                  _currentTime.subtract(
                                    Duration(hours: 1),
                                  ),
                                );
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.blueGrey[900],
                          elevation: 20,
                          margin: EdgeInsetsDirectional.only(
                              top: 5, start: 10, end: 10, bottom: 5),
                          child: ListTile(
                            onTap: () {},
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_userData.image),
                                ),
                              ),
                            ),
                            title: Text(_userData.name),
                            subtitle: Text(" "),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                _isUserActive
                                    ? Text(
                                        "Active Now",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    : Text(
                                        "Last seen",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                _isUserActive
                                    ? Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )
                                    : Text(
                                        timeago.format(
                                          _userData.lastseen.toDate(),
                                        ),
                                        style: TextStyle(fontSize: 12),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container();
        });
  }
}
