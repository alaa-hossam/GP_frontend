import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/views/resetPassword.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../widgets/customizeOTPField.dart';
import '../widgets/customizeButton.dart';
import '../widgets/Dimensions.dart';

class Getotp extends StatefulWidget {
  static String id = "GetOtpScreen";

  String email ;

  Getotp(this.email);

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
  verifyCustomer(String code , String email)async{
    await customer.verifyCustomer(code, email);
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
                SizedBox(height:SizeConfig.horizontalBlock * 50,),
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
                        'Please enter the 6 digit code sent to your email.',
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
                          MyTextFormField(controller: code1 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10),
                          MyTextFormField(controller: code2 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10),
                          MyTextFormField(controller: code3 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10),
                          MyTextFormField(controller: code4 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10)
                          ,MyTextFormField(controller: code5 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10),
                          MyTextFormField(controller: code6 ,
                            width: SizeConfig.horizontalBlock * 50,
                            height: SizeConfig.verticalBlock * 60,),
                          SizedBox(width: SizeConfig.horizontalBlock * 10),
                          // Customizeotpfield(),
                          // SizedBox(width: SizeConfig.horizontalBlock * 10),
                          // Customizeotpfield(),
                          // SizedBox(width: SizeConfig.horizontalBlock * 10),
                          // Customizeotpfield(),
                          // SizedBox(width: SizeConfig.horizontalBlock * 23),
                          // Customizeotpfield(),
                          // SizedBox(width: SizeConfig.horizontalBlock * 10),
                          // Customizeotpfield(),
                          // SizedBox(width: SizeConfig.horizontalBlock * 10),
                          // Customizeotpfield(),
                        ],
                      ),
                      SizedBox(height: SizeConfig.verticalBlock * 10,),

                      Text(
                        '00:60',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB36995),
                          fontSize: SizeConfig.textRatio * 15,
                          fontFamily: 'Roboto-regular',
                        ),
                      ),
                      SizedBox(height: SizeConfig.verticalBlock * 10,),
                      Text(
                        'Resend Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF5095B0),
                          fontSize: SizeConfig.textRatio * 16,
                          fontFamily: 'Roboto-medium',
                        ),
                      ),
                      SizedBox(height: SizeConfig.verticalBlock * 16,),

                      customizeButton(buttonName: "Verify", buttonColor: SizeConfig.iconColor, fontColor: Color(0xFFF5F5F5),onClickButton: () {
                        // Navigator.pushNamed(
                        //     context,
                        //     resetPassword.id);
                        String code = code1.text +code2.text +code3.text +code4.text
                        +code5.text + code6.text;
                        verifyCustomer(code, widget.email);
                      })
                    ],

                  ),
                ),

              ],
            )
          ],
        ),
    );
  }
}
