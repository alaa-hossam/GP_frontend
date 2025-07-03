import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/ViewModels/messageViewModel.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../Models/messageModel.dart';
import 'ChatDetails.dart';

class ChatView extends StatefulWidget {
  static String id = "Chat View";
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late Future<String> userIdFuture;
  customerViewModel CVM = customerViewModel();
  ChatViewModel chatVM = ChatViewModel();

  Future<String> getUserId() async {
    Token token = Token();
    String? id = await token.getUUID();
    return id ?? "";
  }

  @override
  void initState() {
    userIdFuture = getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar("my Chats",
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          )),
      body: FutureBuilder<String>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          String currentUserId = snapshot.data!;

          return StreamBuilder<List<String>>(
            stream: chatVM.getContactedUserIds(currentUserId),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
                return Center(child: Text("No chats yet"));
              }

              final userIds = chatSnapshot.data!;

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadChatData(currentUserId, userIds),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chatDataList = dataSnapshot.data!;

                  return ListView.builder(
                    itemCount: chatDataList.length,
                    itemBuilder: (context, index) {
                      final chatData = chatDataList[index];
                      final otherUserId = chatData['userId'];
                      final name = chatData['name'];
                      final imageUrl = chatData['image'];
                      final lastMessage = chatData['message'];

                      return ListTile(
                        leading: Container(
                          width: 60 * SizeConfig.verticalBlock,
                          height: 60 * SizeConfig.verticalBlock,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SizeConfig.secondColor,
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.all(2.0 * SizeConfig.verticalBlock),
                            child: CircleAvatar(
                              backgroundImage:
                                  imageUrl != null && imageUrl != ""
                                      ? NetworkImage(imageUrl)
                                      : AssetImage("assets/images/logo.png")
                                          as ImageProvider,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                        title: Text(
                          name ?? "",
                          style: GoogleFonts.roboto(
                              fontSize: 20 * SizeConfig.textRatio,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(lastMessage ?? "No messages yet" ,
                          style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold , color: Color(0x503C3C3C)),),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatDetails.id,
                            arguments: {
                              'id': currentUserId,
                              'otherId': otherUserId
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadChatData(
      String currentUserId, List<String> userIds) async {
    List<Map<String, dynamic>> chatDataList = [];

    for (String otherUserId in userIds) {
      final userFuture = CVM.fetchUser(otherUserId);
      final messageFuture = chatVM.getLastMessage(currentUserId, otherUserId);

      final results = await Future.wait([userFuture, messageFuture]);

      final CustomerModel? user = results[0] as CustomerModel?;
      final MessageModel? lastMessage = results[1] as MessageModel?;

      chatDataList.add({
        'userId': otherUserId,
        'name': user?.name ?? '',
        'image': user?.profileImage ?? '',
        'message': lastMessage?.content ?? 'No messages yet',
      });
    }

    return chatDataList;
  }
}
