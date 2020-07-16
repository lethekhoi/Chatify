import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  Text,
  Image,
}

class Message {
  final String senderID;
  final String message;
  final Timestamp timestamp;
  final MessageType type;

  Message({this.senderID, this.message, this.timestamp, this.type});
}
