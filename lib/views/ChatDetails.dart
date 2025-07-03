import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/messageViewModel.dart';
import 'package:gp_frontend/Models/messageModel.dart';

class ChatDetails extends StatefulWidget {
  static String  id = "Chat Details screen";


  const ChatDetails({
    Key? key,

  }) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetails> {
  final TextEditingController _controller = TextEditingController();
  final ChatViewModel chatVM = ChatViewModel();



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String , dynamic>;
    final id = args['id'];
    final otherID = args['otherId'];

    void sendMessage() {
      if (_controller.text.trim().isEmpty) return;

      final message = MessageModel(
        id: '', // Firestore will generate this
        senderId: id,
        receiverId: otherID,
        content: _controller.text.trim(),
        timestamp: DateTime.now(),
      );

      chatVM.sendMessage(message);
      _controller.clear();
    }



    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatVM.getMessages(id, otherID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - index - 1];
                    final isMe = msg.senderId == id;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.content,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
