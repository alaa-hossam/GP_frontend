import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/ViewModels/messageViewModel.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../Models/messageModel.dart';

class ChatView extends StatefulWidget {
  static String id = "Chat View";
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();



}


class _ChatViewState extends State<ChatView> {
  late Future<String> userIdFuture;
  customerViewModel CVM = customerViewModel();

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
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ))),
      body: FutureBuilder<String>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("User ID not found"));
          }

          String id = snapshot.data!;

          return StreamBuilder<List<String>>(
            stream: ChatViewModel().getContactedUserIds(id),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
                return Center(child: Text("No chats yet"));
              }

              final userIds = chatSnapshot.data!;

              return ListView.builder(
                itemCount: userIds.length,
                itemBuilder: (context, index) {
                  final otherUserId = userIds[index];

                  return FutureBuilder<MessageModel?>(
                    future: ChatViewModel().getLastMessage(id, otherUserId),
                    builder: (context, messageSnapshot) {
                      final lastMessage = messageSnapshot.data?.content ?? "No messages yet";

                      return FutureBuilder<CustomerModel?>(

                        future: CVM.fetchUser(otherUserId),
                        builder: (context, imageSnapshot) {
                          final imageUrl , name;
                          if( imageSnapshot.data != null){
                             imageUrl = imageSnapshot.data!.profileImage;
                             name = imageSnapshot.data!.name;
                          }else{
                            imageUrl = "";
                            name = "";

                          }

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 40 * SizeConfig.verticalBlock,
                              backgroundColor: Colors.transparent,
                              backgroundImage: imageUrl != "" && imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : AssetImage("assets/images/logo.png") as ImageProvider,
                            ),
                            title: Text(name ?? ""),
                            subtitle: Text(lastMessage),
                            onTap: () {
                              // Navigate to detailed chat screen
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
}