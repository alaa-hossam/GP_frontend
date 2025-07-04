import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/messageModel.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generates a consistent chat ID by sorting user IDs alphabetically
  String getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Sends a message to the Firestore chat document
  Future<void> sendMessage(MessageModel message) async {
    final chatId = getChatId(message.senderId, message.receiverId);

    // 1. Ensure chat document exists
    final chatDoc = _firestore.collection("chats").doc(chatId);
    final chatDocSnapshot = await chatDoc.get();

    if (!chatDocSnapshot.exists) {
      await chatDoc.set({
        'participants': [message.senderId, message.receiverId],
        'lastUpdated': FieldValue.serverTimestamp(), // optional
      });
    }

    // 2. Add the message to the subcollection
    await chatDoc.collection("messages").add(message.toJson());
  }


  /// Retrieves messages between two users, ordered by timestamp
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

  /// Retrieves all chat partner IDs (users the current user has chatted with)
  Stream<List<String>> getContactedUserIds(String currentUserId) {

    return _firestore.collection("chats").snapshots().map((snapshot) {
      List<String> chatUserIds = [];
      print(currentUserId);
      print(chatUserIds);

      for (var doc in snapshot.docs) {
        final chatId = doc.id;
        final parts = chatId.split("_");
        print(snapshot.docs.length);
        print(chatId);
        print(parts);

        if (parts.length == 2 &&
            (parts[0] == currentUserId || parts[1] == currentUserId)) {
          final otherUserId = parts[0] == currentUserId ? parts[1] : parts[0];
          if (!chatUserIds.contains(otherUserId)) {
            chatUserIds.add(otherUserId);
          }
        }
      }

      return chatUserIds;
    });
  }

  Future<MessageModel?> getLastMessage(String currentUserId, String otherUserId) async {
    final chatId = getChatId(currentUserId, otherUserId);

    final snapshot = await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return MessageModel.fromJson(doc.id, doc.data());
    }
    return null;
  }

}
