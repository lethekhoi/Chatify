import 'package:chatify_app/pages/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();
  Firestore _db;
  DBService() {
    _db = Firestore.instance;
  }
  String _userCollection = "Users";
  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) async {
    try {
      return await _db.collection(_userCollection).document(_uid).setData({
        "name": _name,
        "image": _imageURL,
        "email": _email,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateImage(String _uid, String _imageURL) async {
    try {
      return await _db
          .collection(_userCollection)
          .document(_uid)
          .updateData({"image": _imageURL}).then((_) {
            print("update image success");
          });
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }
}
