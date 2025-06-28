import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/messageModel.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    print("iiiiiiiiiiiiiiiiiiiidddddddddddddddddddddddddddd");
    print('${sorted[0]}_${sorted[1]}');
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> sendMessage(MessageModel message) async {
    final chatId = getChatId(message.senderId, message.receiverId);
    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(message.toJson());
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String otherUserId) {
    final chatId = getChatId(currentUserId, otherUserId);
    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.id, doc.data()))
        .toList());
  }
}
