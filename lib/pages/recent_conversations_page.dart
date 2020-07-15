import 'package:chatify_app/models/contact.dart';
import 'package:chatify_app/models/conversation.dart';
import 'package:chatify_app/providers/auth_provider.dart';
import 'package:chatify_app/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecentConversationsPage extends StatefulWidget {
  final double _height;
  final double _width;
  RecentConversationsPage(this._height, this._width);
  @override
  _RecentConversationsPageState createState() =>
      _RecentConversationsPageState();
}

class _RecentConversationsPageState extends State<RecentConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget._height,
      width: widget._width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListViewWidget(),
      ),
    );
  }

  Widget _conversationsListViewWidget() {
    return Builder(builder: (BuildContext _context) {
      var _auth = Provider.of<AuthProvider>(_context);
      return Container(
        margin: EdgeInsetsDirectional.only(top: 10),
        height: widget._height,
        width: widget._width,
        child: StreamBuilder<List<Conversation>>(
          stream: DBService.instance.getUserConversations(_auth.user.uid),
          builder: (_context, _snapshot) {
            var _data = _snapshot.data;
            return _data.length != 0
                ? ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (_context, _index) {
                      return StreamBuilder<Contact>(
                          stream:
                              DBService.instance.getUserData(_data[_index].id),
                          builder: (_context1, _snapshot1) {
                            return _snapshot1.hasData
                                ? Card(
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                _snapshot1.data.image),
                                          ),
                                        ),
                                      ),
                                      title: Text(_data[_index].name),
                                      subtitle: Text(_data[_index].lastMessage),
                                      trailing:
                                          _listTrailingWidget(_data[_index]),
                                    ),
                                  )
                                : SpinKitWanderingCubes(
                                    color: Colors.blue,
                                    size: 50.0,
                                  );
                          });
                    },
                  )
                : Align(
                    child: Text(
                    "No coversation yet!",
                    style: TextStyle(fontSize: 15),
                  ));
          },
        ),
      );
    });
  }

  Widget _listTrailingWidget(Conversation _data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Last Message",
          style: TextStyle(fontSize: 12),
        ),
        Text(
          timeago.format(_data.timestamp.toDate()),
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
