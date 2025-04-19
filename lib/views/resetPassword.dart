import 'package:flutter/material.dart';
import 'package:gp_frontend/views/logInView.dart';
import '../ViewModels/customerViewModel.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import 'Home.dart';

class resetPassword extends StatefulWidget {
  static String id = "ResetPasswordScreen";
  final String email;
  resetPassword(this.email);

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePass = true;
  bool obscureConfirmPass= true;
  customerViewModel cvm= customerViewModel();
  bool _isLoading = false;

  togglePasswordVisibility() {
    setState(() {
      obscurePass = !obscurePass;
    });
  }

  toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmPass = !obscureConfirmPass;
    });
  }

  Future<String> reasetPass() async {
    try {
      return await cvm.ResetPass(
          email: widget.email,
          newPass: passwordController.text,
          confirmPass: confirmPasswordController.text
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.verticalBlock * 200,
                right: SizeConfig.horizontalBlock * 10,
                left: SizeConfig.horizontalBlock * 10,
              ),
              child: Form(
                key: _globalKey,
                child: Center(
                  child: Column(
                    spacing: SizeConfig.verticalBlock *10,
                    children: [
                      Text(
                        'Enter new password',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: SizeConfig.textRatio * 24,
                          fontFamily: 'title-bold',
                        ),
                      ),
                      Text(
                        'Your new password must be different from previous used passwords.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0x803C3C3C),
                          fontSize: SizeConfig.textRatio * 16,
                          fontFamily: 'caption-regular',
                        ),
                      ),
                      MyTextFormField(
                        controller: passwordController,
                        hintName: "Password",
                        icon: Icons.lock,
                        isObscureText: obscurePass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePass ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                        maxLines: 1,
                      ),
                      MyTextFormField(
                        controller: confirmPasswordController,
                        hintName: "Confirm Password",
                        icon: Icons.lock,
                        isObscureText: obscureConfirmPass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: toggleConfirmPasswordVisibility,
                        ),
                        maxLines: 1,
                      ),
                      customizeButton(
                        buttonName: 'Reset Password',
                        buttonColor: SizeConfig.iconColor,
                        fontColor: const Color(0xFFF5F5F5),
                        onClickButton: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          String response = await reasetPass();

                          setState(() {
                            _isLoading = false;
                          });

                          if (response == "Password Changed Successfully") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Password Changed Successfully!")),
                            );
                            Navigator.pushNamed(context, Home.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response)),
                            );
                          }
                        },
                      ),
                      Row(
                        spacing: SizeConfig.horizontalBlock *5,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => logIn()),
                              );
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
          ),
          // Show loading indicator when _isLoading is true
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
