import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class Conversation {
  final String id;
  final String conversationID;
  // final String image;
  final String lastMessage;
  final Timestamp timestamp;
  final String name;
  final int unseenCount;

  Conversation(
      {this.id,
      this.conversationID,
      // this.image,
      this.lastMessage,
      this.timestamp,
      this.name,
      this.unseenCount});

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    return Conversation(
      id: _snapshot.documentID,
      conversationID: _data["conversationID"],
      // image: _data["image"],
      lastMessage: _data["lastMessage"] != null ? _data["lastMessage"] : "",
      timestamp: _data["timestamp"],
      name: _data["name"],
      unseenCount: _data["unseenCount"],
    );
  }
}

class ConversationDetail {
  final String id;
  final List members;
  final List<Message> messages;
  final String ownerID;

  ConversationDetail({this.id, this.members, this.messages, this.ownerID});

  factory ConversationDetail.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    List _message = _data["messages"];
    if (_message != null) {
      _message = _message.map((_m) {
        var _messageType =
            _m["type"] == "text" ? MessageType.Text : MessageType.Image;
        return Message(
            senderID: _m["senderID"],
            message: _m["message"],
            timestamp: _m["timestamp"],
            type: _messageType);
      }).toList();
    }
    return ConversationDetail(
      id: _snapshot.documentID,
      members: _data["members"],
      messages: _message,
      ownerID: _data["ownerID"],
    );
  }
}
