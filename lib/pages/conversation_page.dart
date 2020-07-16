import 'package:chatify_app/models/conversation.dart';
import 'package:chatify_app/models/message.dart';
import 'package:chatify_app/providers/auth_provider.dart';
import 'package:chatify_app/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationPage extends StatefulWidget {
  String _conversationID;
  String _receiverID;
  String _receiverImage;
  String _receiverName;

  ConversationPage(this._conversationID, this._receiverID, this._receiverImage,
      this._receiverName);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  double _deviceHeight;
  double _deviceWidth;

  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  String _messageText;
  _ConversationPageState() {
    _formKey = GlobalKey<FormState>();
    _messageText = "";
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(
          this.widget._receiverName,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationPageUI(),
      ),
    );
  }

  Widget _conversationPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _messageListView(),
              _messageField(_context),
            ],
          ),
        );
      },
    );
  }

  Widget _messageListView() {
    return Flexible(
      child: StreamBuilder<ConversationDetail>(
          stream:
              DBService.instance.getConversation(this.widget._conversationID),
          builder: (BuildContext _context, _snapshot) {
            var _conversationData = _snapshot.data;
            if (_conversationData != null) {
              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _conversationData.messages.length,
                itemBuilder: (BuildContext _context, int _index) {
                  int index = _conversationData.messages.length - _index - 1;
                  var _message = _conversationData.messages[index];
                  bool _isOwnMessage = _message.senderID == _auth.user.uid;
                  return _messageListViewChild(_isOwnMessage, _message);
                },
              );
            } else {
              return SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
            }
          }),
    );
  }

  Widget _messageListViewChild(bool _isOwnMessage, Message _message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          !_isOwnMessage ? _userImageWidget() : Container(),
          _textMessageBubble(_isOwnMessage, _message),
        ],
      ),
    );
  }

  Widget _userImageWidget() {
    return Container(
      alignment: Alignment.center,
      height: _deviceHeight * 0.06,
      width: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(500),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(this.widget._receiverImage),
        ),
      ),
    );
  }

  Widget _textMessageBubble(bool _isOwnMessage, Message _message) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];

    return _isOwnMessage
        ? _sendMessageLayout(_colorScheme, _message)
        : _receiveMessageLayout(_colorScheme, _message);
  }

  Widget _sendMessageLayout(List<Color> _colorScheme, Message _message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: _colorScheme,
              stops: [0.30, 0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    minWidth: 0,
                    maxWidth: _deviceWidth * 0.7,
                    maxHeight: _deviceHeight * 0.7,
                    minHeight: 0),
                child: Text(
                  _message.message,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Text(
                timeago.format(_message.timestamp.toDate()),
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _receiveMessageLayout(List<Color> _colorScheme, Message _message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: _colorScheme,
              stops: [0.30, 0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    minWidth: 0,
                    maxWidth: _deviceWidth * 0.75,
                    maxHeight: _deviceHeight * 0.75,
                    minHeight: 0),
                child: Text(
                  _message.message,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Text(
                timeago.format(_message.timestamp.toDate()),
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageField(BuildContext _context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 10),
      height: _deviceHeight * 0.08,
      width: _deviceWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _messageTextField(),
            _sendMessageButton(_context),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.6,
      child: TextFormField(
        validator: (_input) {
          if (_input.length == 0) {
            return "Please enter a message";
          }
          return null;
        },
        onSaved: (_input) {
          setState(() {
            _messageText = _input;
          });
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type a message",
        ),
        autocorrect: false,
      ),
    );
  }

  Widget _sendMessageButton(BuildContext _context) {
    return IconButton(
      alignment: Alignment.centerRight,
      icon: new Icon(
        Icons.send,
        color: Colors.white,
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
         
          DBService.instance.sendMessage(
            this.widget._conversationID,
            Message(
                message: _messageText,
                senderID: _auth.user.uid,
                timestamp: Timestamp.now(),
                type: MessageType.Text),
          );
          _formKey.currentState.reset();
          FocusScope.of(_context).unfocus();
        }
      },
    );
  }

  Widget _imageMessageButton() {
    return IconButton(
      alignment: Alignment.centerRight,
      icon: new Icon(
        Icons.camera_enhance,
        color: Colors.blue,
      ),
      onPressed: () {},
    );
  }
}
