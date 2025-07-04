import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/messageViewModel.dart';
import 'package:gp_frontend/Models/messageModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';

class ChatDetails extends StatefulWidget {
  static String id = "Chat Details screen";

  const ChatDetails({Key? key}) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetails> {
  final TextEditingController _controller = TextEditingController();
  final ChatViewModel chatVM = ChatViewModel();

  late String id;
  late String otherID;
  final FocusNode _focusNode = FocusNode();
  bool write = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        write = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = args['id'];
    otherID = args['otherId'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: SizeConfig.textRatio * 15),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chat',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.horizontalBlock),
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
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14 * SizeConfig.horizontalBlock,
                            vertical: 10 * SizeConfig.verticalBlock,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? SizeConfig.iconColor : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.content,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: SizeConfig.textRatio * 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.verticalBlock * 5,
        top: SizeConfig.verticalBlock * 1,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.horizontalBlock * 5,
        vertical: SizeConfig.verticalBlock * 10,
      ),
      child: Row(
        spacing: SizeConfig.horizontalBlock * 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: MyTextFormField(
              controller: _controller,
              hintName: "Type a message...",
              width:SizeConfig.horizontalBlock * 300
            ),
          ),
            CircleAvatar(
              backgroundColor: SizeConfig.iconColor,
              radius: SizeConfig.horizontalBlock * 24,
              child: IconButton(
                icon: Icon(Icons.send_outlined, color: Colors.white, size: SizeConfig.textRatio * 25),
                onPressed: sendMessage,
              ),
            ),
        ],
      ),
    );
  }

  void sendMessage() {
    print("ssssssssssssend");
    if (_controller.text.trim().isEmpty) return;
    final message = MessageModel(
      id: '',
      senderId: id,
      receiverId: otherID,
      content: _controller.text.trim(),
      timestamp: DateTime.now(),
    );
    chatVM.sendMessage(message);
    _controller.clear();
    _focusNode.unfocus();
  }
}
