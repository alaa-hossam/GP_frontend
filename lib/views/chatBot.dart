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
  String request = "";
  bool write = false;
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
        request = message.text;
      });
      message.clear();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            spacing: SizeConfig.verticalBlock * 10,
            children: [
              Container(
                  width: SizeConfig.horizontalBlock * 361,
                  height: SizeConfig.verticalBlock * 650,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 2, color: SizeConfig.iconColor),
                  ),
                  child: request.isEmpty
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                      : Center(
                          child: Column(
                            spacing: SizeConfig.verticalBlock * 10,
                            children: [
                              Container(
                                height: SizeConfig.verticalBlock * 59,
                                width: SizeConfig.horizontalBlock * 325,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0x80E9E9E9),
                                ),
                                child: Center(
                                    child: Text(
                                  request,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0x803C3C3C),
                                    fontSize: SizeConfig.textRatio * 16,
                                    fontFamily: "Roboto",
                                  ),
                                )),
                              ),
                              CircleAvatar(
                                backgroundColor: SizeConfig.iconColor,
                                radius: SizeConfig.horizontalBlock * 24,
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: Colors.white,
                                      size: SizeConfig.textRatio * 25),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        )),
              Row(
                spacing: SizeConfig.horizontalBlock * 5,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  if (write)
                    CircleAvatar(
                      backgroundColor: SizeConfig.iconColor,
                      radius: SizeConfig.horizontalBlock * 24,
                      child: IconButton(
                        icon: Icon(Icons.send_outlined,
                            color: Colors.white,
                            size: SizeConfig.textRatio * 25),
                        onPressed: sendMessage,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
