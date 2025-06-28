import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/messageModel.dart';
import '../ViewModels/messageViewModel.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatVM.getMessages(widget.currentUserId, widget.otherUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                final messages = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

                return ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(msg.content),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = messageController.text.trim();
                    if (content.isEmpty) return;

                    final message = MessageModel(
                      id: '',
                      senderId: widget.currentUserId,
                      receiverId: widget.otherUserId,
                      content: content,
                      timestamp: DateTime.now(),
                    );

                    chatVM.sendMessage(message);
                    messageController.clear();
                    scrollToBottom();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
