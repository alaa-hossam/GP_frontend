import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/resetPassword.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../widgets/customizeButton.dart';
import '../widgets/Dimensions.dart';

class Getotp extends StatefulWidget {
  static String id = "GetOtpScreen";

  final String email;
  final int back;
  Getotp(this.email,this.back);

  @override
  State<Getotp> createState() => _GetotpState();
}

class _GetotpState extends State<Getotp> {
  customerViewModel customer = customerViewModel();
  TextEditingController code1 = TextEditingController();
  TextEditingController code2 = TextEditingController();
  TextEditingController code3 = TextEditingController();
  TextEditingController code4 = TextEditingController();
  TextEditingController code5 = TextEditingController();
  TextEditingController code6 = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  int remainingTime = 60; // Initial countdown time in seconds
  bool isButtonEnabled = true; // Verify button state
  Timer? countdownTimer;
  bool _isLoading = false; // Loading state


  @override
  void initState() {
    super.initState();
    startCountdownTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    code1.dispose();
    code2.dispose();
    code3.dispose();
    code4.dispose();
    code5.dispose();
    code6.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    super.dispose();
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          isButtonEnabled = false; // Disable the verify button
        });
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<String> resendCode(String email) async {
    setState(() {
      remainingTime = 60;
      isButtonEnabled = true;
    });
    startCountdownTimer();

    return await customer.resendCode(email);
  }

  Future<String> verifyCustomer(String code, String email) async {
    return await customer.verifyCustomer(code, email);
  }

  Future<String> verfiyResetPassCode(String code) async {
    try {
      return await customer.verfiyResetPassCode(
          email: widget.email, code: code
      );
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getCode() async {
    setState(() {
      remainingTime = 60;
      isButtonEnabled = true;
    });
    startCountdownTimer();
    try {
      return await customer.forgetPassCode(
          email: widget.email
      );
    } catch (e) {
      return e.toString();
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
            color: Color(0xFF292929),
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.horizontalBlock * 50),
              Container(
                width: SizeConfig.horizontalBlock * 363,
                child: Column(
                  children: [
                    Text(
                      'Enter code',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: SizeConfig.textRatio * 24,
                        fontFamily: 'title-bold',
                      ),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),
                    Text(
                      'Please enter the 6-digit code sent to your email.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x803C3C3C),
                        fontSize: SizeConfig.textRatio * 16,
                        fontFamily: 'caption-regular',
                      ),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 30),
                    Row(
                      children: [
                        buildOTPField(code1, focusNode1, focusNode2),
                        SizedBox(width: SizeConfig.horizontalBlock * 10),
                        buildOTPField(code2, focusNode2, focusNode3),
                        SizedBox(width: SizeConfig.horizontalBlock * 10),
                        buildOTPField(code3, focusNode3, focusNode4),
                        SizedBox(width: SizeConfig.horizontalBlock * 20),
                        buildOTPField(code4, focusNode4, focusNode5),
                        SizedBox(width: SizeConfig.horizontalBlock * 10),
                        buildOTPField(code5, focusNode5, focusNode6),
                        SizedBox(width: SizeConfig.horizontalBlock * 10),
                        buildOTPField(code6, focusNode6, null),
                      ],
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),
                    Text(
                      formatTime(remainingTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB36995),
                        fontSize: SizeConfig.textRatio * 15,
                        fontFamily: 'Roboto-regular',
                      ),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),
                    GestureDetector(
                      onTap: () async {
                        if (remainingTime == 0) {
                          if(widget.back == 0){
                            String response = await resendCode(widget.email);

                            if (response == "Code Resend successfully") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Code Resend successfully")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${response}")),
                              );
                            }
                          }else if(widget.back == 1){
                            String response = await getCode();

                            if (response == "Code Resend successfully") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Code Resend successfully")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${response}")),
                              );
                            }
                          }

                        }
                      },
                      child: Text(
                        'Resend Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: remainingTime == 0
                              ? Color(0xFF5095B0)
                              : Colors.grey,
                          fontSize: SizeConfig.textRatio * 16,
                          fontFamily: 'Roboto-medium',
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 16),
                    customizeButton(
                      buttonName: "Verify",
                      buttonColor: isButtonEnabled
                          ? SizeConfig.iconColor
                          : Colors.grey, // Change button color based on state
                      fontColor: Color(0xFFF5F5F5),
                      onClickButton: () async {
                        if (isButtonEnabled) {
                          String code = code1.text +
                              code2.text +
                              code3.text +
                              code4.text +
                              code5.text +
                              code6.text;
                          setState(() {
                            _isLoading = true; // Set loading to true
                          });
                          if(widget.back == 0){
                            String response = await verifyCustomer(code, widget.email);

                            setState(() {
                              _isLoading = false; // Set loading to true
                            });

                            if (response == "User verified successfully") {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("User verified successfully")),
                              );
                              Navigator.pushReplacementNamed(context, Home.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${response}")),
                              );
                            }
                          } else if(widget.back == 1){
                            String response = await verfiyResetPassCode(code);

                            setState(() {
                              _isLoading = false;
                            });

                            if (response == "Code Verified Successfully") {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Code Verified Successfully")),
                              );
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      resetPassword(widget.email),));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${response}")),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],

      ),
    );
  }

  Widget buildOTPField(TextEditingController controller, FocusNode currentNode,
      FocusNode? nextNode) {
    return MyTextFormField(
      controller: controller,
      focusNode: currentNode,
      width: SizeConfig.horizontalBlock * 50,
      height: SizeConfig.verticalBlock * 60,
      onChanged: (value) {
        if (value.isNotEmpty && nextNode != null) {
          FocusScope.of(context).requestFocus(nextNode);
        }
      },
    );
  }
}