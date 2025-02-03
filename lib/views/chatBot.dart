import 'package:flutter/material.dart';
import '../Models/generateImageModel.dart';
import '../ViewModels/generateImageViewModel.dart';
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
  List<generateImageModel> chatItems = [];
  bool write = false;
  bool edit = false;
  bool isLoading = false; // Show loading indicator when generating image
  int selectedIndex = -1;
  final FocusNode _focusNode = FocusNode();
  final generateImageViewModel imageViewModel = generateImageViewModel();

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

  void sendMessage() async {
    if (message.text.isNotEmpty && !isLoading) {
      print("message is ================= $message.text");
      setState(() {
        chatItems.add(generateImageModel(prompt: message.text, imageUrl: "", isLoading: true));
        isLoading = true;
        edit = false;
        selectedIndex = -1;
      });

      String prompt = message.text;
      message.clear();
      _focusNode.unfocus();

      try {
        // Generate image from API
        String? generatedImagePath = await imageViewModel.generateImage(prompt: prompt);

        setState(() {
          isLoading = false;
          if (generatedImagePath == null || generatedImagePath.isEmpty) {
            // If the image is null or empty, remove the last item and show an error message
            chatItems.removeLast();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Invalid prompt. Please try again."),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // If the image is generated successfully, update the last item
            chatItems.last = generateImageModel(prompt: prompt, imageUrl: generatedImagePath, isLoading: false);
          }
        });

        // Save generated image if it's not null
        if (generatedImagePath != null && generatedImagePath.isNotEmpty) {
          await imageViewModel.saveGeneratedImage(prompt: prompt, imagePath: generatedImagePath);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          chatItems.removeLast();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to generate image. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }

  void editMessage(int index) {
    if (!isLoading) {
      setState(() {
        message.text = chatItems[index].prompt;
        edit = true;
        write = true;
        selectedIndex = index;
        _focusNode.requestFocus();
      });
    }
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
                  SizedBox(height: SizeConfig.verticalBlock * 20),
                  _buildInfoContainer("Generate all the craft images you want."),
                  _buildInfoContainer("Answer all your questions about handicraft"),
                  _buildInfoContainer("Conversational AI (I can only send a photos)"),
                ],
              )
                  : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      spacing: SizeConfig.verticalBlock * 10,
                      children: [
                        SizedBox(height: SizeConfig.verticalBlock * 20),
                        for (int i = 0; i < chatItems.length; i++)
                          _buildChatItem(i),
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
                          _focusNode.unfocus();
                          setState(() {
                            write = false;
                            edit = false;
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
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String text) {
    return Container(
      height: SizeConfig.verticalBlock * 59,
      width: SizeConfig.horizontalBlock * 325,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0x80E9E9E9),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0x803C3C3C),
            fontSize: SizeConfig.textRatio * 16,
            fontFamily: "Roboto",
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(int index) {
    return Column(
      spacing: SizeConfig.horizontalBlock * 10,
      children: [
        // Message Row
        Row(
          spacing: SizeConfig.horizontalBlock * 5,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: selectedIndex == index ? SizeConfig.iconColor : Colors.white,
              radius: SizeConfig.horizontalBlock * 20,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: selectedIndex == index ? Colors.white : SizeConfig.iconColor,
                  size: SizeConfig.textRatio * 20,
                ),
                onPressed: () => editMessage(index),
              ),
            ),
            Flexible(
              child: IntrinsicWidth(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: SizeConfig.horizontalBlock * 100,
                    maxWidth: SizeConfig.horizontalBlock * 325,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalBlock * 10,
                    vertical: SizeConfig.verticalBlock * 10,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(2),
                    ),
                    color: SizeConfig.iconColor,
                  ),
                  child: Text(
                    chatItems[index].prompt,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.textRatio * 16,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Image Row
        if (chatItems[index].isLoading)
          CircularProgressIndicator()
        else if (chatItems[index].imageUrl.isEmpty || !Uri.parse(chatItems[index].imageUrl).isAbsolute)
          Container(
            width: SizeConfig.horizontalBlock * 237,
            height: SizeConfig.verticalBlock * 256,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "The prompt must involve a handmade product",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: SizeConfig.textRatio * 16,
                  fontFamily: "Roboto",
                ),
              ),
            ),
          )
        else
          Row(
            spacing: SizeConfig.horizontalBlock * 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                chatItems[index].imageUrl,
                width: SizeConfig.horizontalBlock * 237,
                height: SizeConfig.verticalBlock * 256,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: SizeConfig.horizontalBlock * 237,
                    height: SizeConfig.verticalBlock * 256,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Failed to load image",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: SizeConfig.textRatio * 16,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Share Button
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

      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.verticalBlock * 5),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.horizontalBlock * 5,
        vertical: SizeConfig.verticalBlock * 10,
      ),
      child: Row(
        spacing: SizeConfig.horizontalBlock * 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (edit || chatItems.isEmpty)
            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: MyTextFormField(
                controller: message,
                hintName: "Ask Me",
                focusNode: _focusNode,
                width: write ? SizeConfig.horizontalBlock * 300 : SizeConfig.horizontalBlock * 361,
              ),
            ),
          if (write && (edit || chatItems.isEmpty))
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
}