import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/messageModel.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection("chats").add(message.toJson());
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String otherUserId) {
    return _firestore
        .collection("chats")
        .where("senderId", whereIn: [currentUserId, otherUserId])
        .where("receiverId", whereIn: [currentUserId, otherUserId])
        .orderBy("timestamp")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.id, doc.data()))
        .where((msg) =>
    (msg.senderId == currentUserId && msg.receiverId == otherUserId) ||
        (msg.senderId == otherUserId && msg.receiverId == currentUserId))
        .toList());
  }
}
