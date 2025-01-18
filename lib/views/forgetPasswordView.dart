import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import 'GetOTP.dart';

class forgetPassword extends StatefulWidget {
  static String id = "ForgetPasswordScreen";
  @override
  State<forgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<forgetPassword> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.verticalBlock * 200 ,
              right: SizeConfig.horizontalBlock * 10 ,
              left: SizeConfig.horizontalBlock * 10),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing:SizeConfig.verticalBlock * 10 ,
              children: [
                Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: SizeConfig.textRatio * 24,
                    fontFamily: 'title-bold',
                  ),
                ),
                Text(
                  'Enter your email address associated with your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x803C3C3C),
                    fontSize: SizeConfig.textRatio * 16,
                    fontFamily: 'caption-regular',
                  ),
                ),
                MyTextFormField(
                  controller: emailController,
                  hintName: "Email",
                  icon: Icons.email_outlined,
                ),
                customizeButton(buttonName: 'Send Code',buttonColor: SizeConfig.iconColor, fontColor: Color(0xFFF5F5F5),onClickButton: () {
                  Navigator.pushNamed(
                      context,
                      Getotp.id);
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing:SizeConfig.horizontalBlock * 5 ,
                  children: [
                    Text(
                      "Remember Password?",
                      style: TextStyle(
                        fontFamily: 'roboto-regular',
                        fontSize: SizeConfig.textRatio * 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: SizeConfig.iconColor,
                          fontFamily: 'roboto-medium',
                          fontSize: SizeConfig.textRatio * 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
