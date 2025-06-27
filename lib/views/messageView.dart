import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/messageModel.dart';
import '../ViewModels/messageViewModel.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const ChatScreen({required this.currentUserId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatVM.getMessages(widget.currentUserId, widget.otherUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg.senderId == widget.currentUserId
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        color: Colors.blue[100],
                        child: Text(msg.content),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: messageController),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = MessageModel(
                      id: '',
                      senderId: widget.currentUserId,
                      receiverId: widget.otherUserId,
                      content: messageController.text.trim(),
                      timestamp: DateTime.now(),
                    );
                    chatVM.sendMessage(message);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
