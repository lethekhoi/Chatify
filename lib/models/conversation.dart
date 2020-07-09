import 'package:cloud_firestore/cloud_firestore.dart';

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
