import 'package:chat_app/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
      return null;
    });
  }

  static updateUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: Constants.myName)
        .getDocuments()
        .then((value) => print(value));
  }

  static getUserByEmail(String email) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  static uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  static createChatRoom(String chatroomid, chatRoomMap) async {
    await Firestore.instance
        .collection('chatRoom')
        .document(chatroomid)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  static addConvoMsg(String chatRoomId, messageMap) async {
    Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  static getConvoMsg(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  static getChatRooms(String username) {
    return Firestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
