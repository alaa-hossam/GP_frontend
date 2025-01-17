import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
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
  customerViewModel cmv= customerViewModel();

  togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
//   getUser()async{
//     return await cmv.fetchUser("1463d4fd-1f57-46f4-8c2f-af4bfe9ff05e");
// }
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
                  children: [
                    Text("Logo"),
                    SizedBox(height: SizeConfig.verticalBlock * 80),
                    MyTextFormField(
                        controller: email,
                        hintName: "Email",
                        icon: Icons.email_outlined
                    ),
                    SizedBox(
                      height: SizeConfig.verticalBlock *10,
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
                    SizedBox(
                      height: SizeConfig.verticalBlock *10,
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
                    SizedBox(
                      height: SizeConfig.verticalBlock *10,
                    ),
                    customizeButton(buttonName: 'Log In', buttonColor: SizeConfig.iconColor,fontColor:const Color(0xFFF5F5F5),onClickButton: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
                    },),
                    SizedBox(height: SizeConfig.verticalBlock * 150),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.horizontalBlock * 140,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:const BoxDecoration(
                              color: Color(0xFFD8DADC)
                          ),),
                        SizedBox(width: SizeConfig.horizontalBlock * 5),
                        Text("Or With", style: TextStyle(fontSize: SizeConfig.textRatio * 14),),
                        SizedBox(width: SizeConfig.horizontalBlock * 5),
                        Container(
                          width: SizeConfig.horizontalBlock * 140,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:const BoxDecoration(
                              color: Color(0xFFD8DADC)
                          ),)
                      ],
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),
                    customizeButton(buttonName: 'Google',buttonColor: Colors.white, buttonIcon: Icons.mail,fontColor: Colors.black, buttonBorder: Border.all(color: SizeConfig.iconColor),),
                    SizedBox(height: SizeConfig.verticalBlock * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontFamily: 'roboto-regular',
                            fontSize: SizeConfig.textRatio * 16,
                          ),
                        ),
                        
                        SizedBox(width: SizeConfig.horizontalBlock * 5),
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
                    // FutureBuilder(
                    //   future: getUser(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return Padding(
                    //         padding: EdgeInsets.only(left: SizeConfig.horizontalBlock * 5),
                    //         child: Text("Loading..."),
                    //       );
                    //     } else if (snapshot.hasError) {
                    //       print(snapshot.error);
                    //       return Padding(
                    //         padding: EdgeInsets.only(left: SizeConfig.horizontalBlock * 5),
                    //         child: Text("Error: ${snapshot.error}"),
                    //       );
                    //     } else if (snapshot.hasData) {
                    //       return Padding(
                    //         padding: EdgeInsets.only(left: SizeConfig.horizontalBlock * 5),
                    //         child: Text(
                    //           "${snapshot.data}",
                    //           style: TextStyle(
                    //             color: Colors.green,
                    //             fontFamily: 'roboto-regular',
                    //             fontSize: SizeConfig.textRatio * 16,
                    //           ),
                    //         ),
                    //       );
                    //     } else {
                    //       return Padding(
                    //         padding: EdgeInsets.only(left: SizeConfig.horizontalBlock * 5),
                    //         child: Text("No Data"),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
                          ),
            ),
          ),
    );
  }
}
