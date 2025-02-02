import 'package:flutter/material.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';

class AIChat extends StatefulWidget {
  static String id = "AIChatScreen";
  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  TextEditingController message = TextEditingController();
  List<Map<String, dynamic>> chatItems = []; // List to store chat items (messages and images)
  List<String> imagesPath = [
    "assets/images/p1.jpg",
    "assets/images/p2.jpg",
    "assets/images/p3.jpg"
  ];
  int currentImageIndex = 0;
  bool write = false;
  bool edit = false;
  int selectedIndex = -1; // Track the index of the selected message
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      write = _focusNode.hasFocus;
    });
  }

  void sendMessage() {
    if (message.text.isNotEmpty) {
      setState(() {
        chatItems.add({"type": "text", "content": message.text}); // Add the new message to the list
        chatItems.add({"type": "image", "content": imagesPath[currentImageIndex]});
        currentImageIndex = (currentImageIndex + 1) % imagesPath.length;
        message.clear();
        edit = false; // Reset edit mode
        selectedIndex = -1; // Reset selected index
      });
    }
  }
  void editMessage(int index) {
    setState(() {
      message.text = chatItems[index]["content"]; // Load the message into the text field
      edit = true; // Enable edit mode
      write = true; // Focus the text field
      selectedIndex = index; // Set the selected index
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFF292929),
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "AI Chat",
          style: TextStyle(
            fontFamily: "Rubik",
            fontSize: SizeConfig.textRatio * 20,
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: SizeConfig.horizontalBlock * 361,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalBlock * 10,
                vertical: SizeConfig.verticalBlock * 5,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(width: 2, color: SizeConfig.iconColor),
              ),
              child: chatItems.isEmpty
                  ? Column(
                spacing: SizeConfig.verticalBlock * 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/robot.png',
                    width: SizeConfig.verticalBlock * 65,
                    height: SizeConfig.verticalBlock * 65,
                  ),
                  SizedBox(
                    height: SizeConfig.verticalBlock * 20,
                  ),
                  Container(
                    height: SizeConfig.verticalBlock * 59,
                    width: SizeConfig.horizontalBlock * 325,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0x80E9E9E9),
                    ),
                    child: Center(
                        child: Text(
                          "Generate all the craft images you want.",
                          style: TextStyle(
                            color: const Color(0x803C3C3C),
                            fontSize: SizeConfig.textRatio * 16,
                            fontFamily: "Roboto",
                          ),
                        )),
                  ),
                  Container(
                    height: SizeConfig.verticalBlock * 59,
                    width: SizeConfig.horizontalBlock * 325,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0x80E9E9E9),
                    ),
                    child: Center(
                        child: Text(
                          "Answer all your questions about handicraft",
                          style: TextStyle(
                            color: const Color(0x803C3C3C),
                            fontSize: SizeConfig.textRatio * 16,
                            fontFamily: "Roboto",
                          ),
                        )),
                  ),
                  Container(
                    height: SizeConfig.verticalBlock * 59,
                    width: SizeConfig.horizontalBlock * 325,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0x80E9E9E9),
                    ),
                    child: Center(
                        child: Text(
                          "Conversational AI (I can only send a photos)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0x803C3C3C),
                            fontSize: SizeConfig.textRatio * 16,
                            fontFamily: "Roboto",
                          ),
                        )),
                  ),
                ],
              )
                  : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      spacing: SizeConfig.verticalBlock * 10,
                      children: [
                        SizedBox(height: SizeConfig.verticalBlock * 20),
                        // Display all chat items (messages and images)
                        for (int i = 0; i < chatItems.length; i++)
                          if (chatItems[i]["type"] == "text")
                            Row(
                              spacing: SizeConfig.horizontalBlock * 5,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: selectedIndex == i
                                      ? SizeConfig.iconColor
                                      : Colors.white,
                                  radius: SizeConfig.horizontalBlock * 20,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: selectedIndex == i
                                          ? Colors.white
                                          : SizeConfig.iconColor,
                                      size: SizeConfig.textRatio * 20,
                                    ),
                                    onPressed: () {
                                      editMessage(
                                          i); // Edit the selected message
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: IntrinsicWidth(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minWidth:
                                        SizeConfig.horizontalBlock * 100,
                                        maxWidth:
                                        SizeConfig.horizontalBlock * 325,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                        SizeConfig.horizontalBlock * 10,
                                        vertical:
                                        SizeConfig.verticalBlock * 10,
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(2),
                                        ),
                                        color: SizeConfig.iconColor,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          chatItems[i]["content"],
                                          textAlign: TextAlign.center,
                                          softWrap:
                                          true, // Enable text wrapping
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            SizeConfig.textRatio * 16,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else if (chatItems[i]["type"] == "image")
                            Row(
                              spacing: SizeConfig.horizontalBlock * 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  chatItems[i]["content"],
                                  width: SizeConfig.horizontalBlock * 237,
                                  height: SizeConfig.verticalBlock * 256,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: SizeConfig.horizontalBlock * 20,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.share_outlined,
                                      color: SizeConfig.iconColor,
                                      size: SizeConfig.textRatio * 20,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: SizeConfig.verticalBlock * 20),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: SizeConfig.iconColor,
                      radius: SizeConfig.horizontalBlock * 24,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: SizeConfig.textRatio * 25,
                        ),
                        onPressed: () {
                          setState(() {
                            write = false;
                            message.clear();
                            chatItems.clear(); // Clear all messages
                            selectedIndex = -1;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalBlock * 5,
              vertical: SizeConfig.verticalBlock * 10,
            ),
            child: Row(
              spacing: SizeConfig.horizontalBlock * 5,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (edit || chatItems.isEmpty)
                  GestureDetector(
                    onTap: () {
                      _focusNode.requestFocus();
                    },
                    child: MyTextFormField(
                      controller: message,
                      hintName: "Ask Me",
                      focusNode: _focusNode,
                      width: write
                          ? SizeConfig.horizontalBlock * 300
                          : SizeConfig.horizontalBlock * 361,
                    ),
                  ),
                if (write && (edit || chatItems.isEmpty))
                  CircleAvatar(
                    backgroundColor: SizeConfig.iconColor,
                    radius: SizeConfig.horizontalBlock * 24,
                    child: IconButton(
                      icon: Icon(Icons.send_outlined,
                          color: Colors.white, size: SizeConfig.textRatio * 25),
                      onPressed: sendMessage,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}