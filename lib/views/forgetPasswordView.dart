import 'package:flutter/material.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/signUpView.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class forgetPassword extends StatefulWidget {
  static String id = "ForgetPasswordScreen";
  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar( // Set this to match your body color
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF292929), size: SizeConfig.textRatio * 15,), // Back arrow color
              onPressed: () {
                Navigator.pop(context); // Handle back navigation
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _globalKey,
                child: SingleChildScrollView(
                  child:
                  Container(
                    padding: EdgeInsets.only(bottom: SizeConfig.verticalBlock * 20),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Forget Password?',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: SizeConfig.textRatio * 24,
                              fontFamily: 'title-bold',
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.verticalBlock *10,
                          ),
                          Container(
                            width: SizeConfig.horizontalBlock * 363,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.textRatio * 15,
                                right: SizeConfig.textRatio * 15,
                              ),
                              child: Text(
                                'Enter your email address associated with your account.',
                                style: TextStyle(
                                  color: Color(0x803C3C3C),
                                  fontSize: SizeConfig.textRatio * 16,
                                  fontFamily: 'caption-regular',
                                ),
                                textAlign: TextAlign.center, // Centers the text horizontally
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.verticalBlock *10,
                          ),
                          MyTextFormField(
                              controller: email,
                              hintName: "Email",
                              icon: Icons.email_outlined
                          ),
                          SizedBox(
                            height: SizeConfig.verticalBlock *10,
                          ),
                          customizeButton(buttonName: 'Send Code'),
                          SizedBox(
                            height: SizeConfig.verticalBlock *10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Remember Password?",style: TextStyle(color: Color(0xFF000000),fontFamily: 'roboto-regular',
                                fontSize: SizeConfig.textRatio * 16,)),
                              SizedBox(width: SizeConfig.horizontalBlock * 5,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, logIn.id);
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(color: Color(0xFF5095B0),fontFamily: 'roboto-medium',
                                    fontSize: SizeConfig.textRatio * 16,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
