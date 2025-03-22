import 'package:flutter/material.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/signUpView.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../SqfliteCodes/Token.dart';
import '../SqfliteCodes/cart.dart';
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
  customerViewModel cvm= customerViewModel();
  bool _isLoading = false;


  togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
      // token.recreateTokensTable();
    });
  }

  Future<String> logInCustomer() async {
    try {

      return await cvm.logIn(
          email: email.text,
          password: password.text
      );
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: SizeConfig.verticalBlock * 200),
              child: Form(
                key: _globalKey,
                child: Center(
                  child: Column(
                    spacing: SizeConfig.verticalBlock * 10,
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
                        maxLines: obscureText ? 1 : null, // Set maxLines to 1 if obscureText is true
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      ),
                      Container(
                        width: SizeConfig.horizontalBlock * 363,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, forgetPassword.id);
                              },
                              child: Text(
                                'Forget password?',
                                style: TextStyle(
                                  color: Color(0xFF5095B0),
                                  fontFamily: 'roboto-medium',
                                  fontSize: SizeConfig.textRatio * 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      customizeButton(
                        buttonName: 'Log In',
                        buttonColor: SizeConfig.iconColor,
                        fontColor: const Color(0xFFF5F5F5),
                        onClickButton: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          String response = await logInCustomer();

                          setState(() {
                            _isLoading = false;
                          });

                          if (response == "User Log In Successfully") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Log In Successful!")),
                            );
                            Navigator.pushReplacementNamed(context, Home.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response)),
                            );
                          }
                        },
                      ),
                      SizedBox(height: SizeConfig.verticalBlock * 100),
                      Row(
                        spacing: SizeConfig.horizontalBlock *5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.horizontalBlock * 140,
                            height: SizeConfig.verticalBlock * 2,
                            decoration: const BoxDecoration(color: Color(0xFFD8DADC)),
                          ),
                          Text(
                            "Or With",
                            style: TextStyle(fontSize: SizeConfig.textRatio * 14),
                          ),
                          Container(
                            width: SizeConfig.horizontalBlock * 140,
                            height: SizeConfig.verticalBlock * 2,
                            decoration: const BoxDecoration(color: Color(0xFFD8DADC)),
                          )
                        ],
                      ),
                      customizeButton(
                        buttonName: 'Google',
                        buttonColor: Colors.white,
                        buttonIcon: Icons.mail,
                        fontColor: Colors.black,
                        buttonBorder: Border.all(color: SizeConfig.iconColor),
                      ),
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
                              Navigator.pushReplacementNamed(context, SignUp.id);
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
          // Loading Indicator (Placed inside Stack)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

}
