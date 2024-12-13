import 'package:flutter/material.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/signUpView.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';

class logIn extends StatefulWidget {
  static String id = "LogInScreen";
  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return  Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: SizeConfig.verticalBlock * 200),
              child: Form(
              key: _globalKey,
              child: Center(
                child: Column(
                  spacing:SizeConfig.verticalBlock * 10 ,
                  children: [
                    Text("Logo"),
                    SizedBox(height: SizeConfig.verticalBlock * 70),
                    MyTextFormField(
                        controller: email,
                        hintName: "Email",
                        icon: Icons.email_outlined
                    ),
                    MyTextFormField(
                      controller: password,
                      hintName: "Password",
                      icon: Icons.lock,
                      isObscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    Container(
                      width: SizeConfig.horizontalBlock *363 ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Aligns children to the end
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, forgetPassword.id);
                            },
                            child: Text('Forget password?',
                              style: TextStyle(
                                color: Color(0xFF5095B0),
                                fontFamily: 'roboto-medium',
                                fontSize: SizeConfig.textRatio * 16,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    customizeButton(buttonName: 'Log In', buttonColor: SizeConfig.iconColor,fontColor:const Color(0xFFF5F5F5),onClickButton: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
                    },),
                    SizedBox(height: SizeConfig.verticalBlock * 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing:SizeConfig.horizontalBlock * 5 ,
                      children: [
                        Container(
                          width: SizeConfig.horizontalBlock * 140,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:const BoxDecoration(
                              color: Color(0xFFD8DADC)
                          ),),
                        Text("Or With", style: TextStyle(fontSize: SizeConfig.textRatio * 14),),
                        Container(
                          width: SizeConfig.horizontalBlock * 140,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:const BoxDecoration(
                              color: Color(0xFFD8DADC)
                          ),)
                      ],
                    ),
                    customizeButton(buttonName: 'Google',buttonColor: Colors.white, buttonIcon: Icons.mail,fontColor: Colors.black, buttonBorder: Border.all(color: SizeConfig.iconColor),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing:SizeConfig.horizontalBlock * 5 ,
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontFamily: 'roboto-regular',
                            fontSize: SizeConfig.textRatio * 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUp.id);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF5095B0),
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
          ),
    );
  }
}
