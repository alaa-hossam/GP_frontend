import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import '../ViewModels/customerViewModel.dart';
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
  customerViewModel cvm= customerViewModel();
  bool _isLoading = false;

  Future<String> getCode() async {
    try {
      return await cvm.forgetPassCode(
          email: emailController.text
      );
    } catch (e) {
      return e.toString();
    }
  }

  @override
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
                child: Column(
                  spacing: SizeConfig.verticalBlock *10,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    customizeButton(
                      buttonName: 'Send Code',
                      buttonColor: SizeConfig.iconColor,
                      fontColor: Color(0xFFF5F5F5),
                      onClickButton: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        String response = await getCode();

                        setState(() {
                          _isLoading = false;
                        });

                        if (response == "Code Send Successfully") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Code Sent Successfully!")),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Getotp(emailController.text,1),
                            ),
                          );
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
          // Loading Overlay (Covers screen when _isLoading is true)
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
