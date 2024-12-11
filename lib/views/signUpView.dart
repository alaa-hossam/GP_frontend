import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/GetOTP.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/widgets/customizeDropDownMenu.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../widgets/customizeButton.dart';

class SignUp extends StatefulWidget {
  static String id = "SignUpScreen";

  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool obscureText = true;
  togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  final List<String> dropDownItems = ["Male", "Female"];

  // The updated _selectDate function to set the selected date to the text field
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Format the date to a readable string (e.g., 'yyyy-MM-dd')
      String formattedDate = pickedDate.toLocal().toString().split(' ')[0];

      // Update the _date controller to display the selected date in the text field
      setState(() {
        _date.text = formattedDate;
      });
    }
  }



  @override
  void dispose() {
    _fullName.dispose();
    _address.dispose();
    _phoneNumber.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Text("Logo"),
                SizedBox(height: SizeConfig.verticalBlock * 80),

                // Full Name Field
                MyTextFormField(
                  controller: _fullName,
                  hintName: "Full Name",
                  icon: Icons.person_outline,
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),

                // Gender Dropdown
                MyDropDownMenu(dropDownItems: dropDownItems, prefixIcon: Icons.female, hintText: "Gender"),
                SizedBox(height: SizeConfig.verticalBlock * 10),

                // Address Field
                MyTextFormField(
                  controller: _address,
                  hintName: "Address",
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),

                // Birth Date Field with Date Picker
                MyTextFormField(
                  controller: _date,
                  hintName: "Birth Date",
                  icon: Icons.date_range,
                  onClickFunction: _selectDate, // Passing the function reference
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),
                MyTextFormField(
                  controller: _phoneNumber,
                  hintName: "Phone Number",
                  icon: Icons.phone_outlined,
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),
                MyTextFormField(
                  controller: _email,
                  hintName: "Email",
                  icon: Icons.mail,
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),
                MyTextFormField(
                  controller: _password,
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
                SizedBox(height: SizeConfig.verticalBlock * 10),


                customizeButton(buttonName: 'Sign Up',buttonColor: SizeConfig.iconColor,
                  fontColor: Color(0xFFF5F5F5),onClickButton: () {
    Navigator.pushNamed(
    context,
    Getotp.id);
    }
                      ),


                SizedBox(height: SizeConfig.verticalBlock * 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeConfig.horizontalBlock * 123,
                      height: SizeConfig.verticalBlock * 2,
                      // margin: EdgeInsets.only(left: SizeConfig.horizontalBlock * 40,
                      //     right: SizeConfig.horizontalBlock * 10),
                      decoration:const BoxDecoration(
                        color: Color(0xFFD8DADC)
                      ),),
                    Text("Or With", style: TextStyle(fontSize: SizeConfig.textRatio * 14),),
                    Container(
                      width: SizeConfig.horizontalBlock * 123,
                      height: SizeConfig.verticalBlock * 2,
                      // margin: EdgeInsets.only(left: SizeConfig.horizontalBlock * 10),
                      decoration:const BoxDecoration(
                          color: Color(0xFFD8DADC)
                      ),)
                  ],
                ),
                SizedBox(height: SizeConfig.verticalBlock * 10),

                customizeButton(buttonName: 'Google',buttonColor: Colors.white,
                  buttonIcon: Icons.mail,fontColor: Colors.black, buttonBorder: Border.all(color: SizeConfig.iconColor),),
                SizedBox(height: SizeConfig.verticalBlock * 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style:TextStyle(fontSize: SizeConfig.textRatio * 14 )),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, logIn.id);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFF5095B0),
                          fontFamily: 'roboto-medium',
                          fontSize: SizeConfig.textRatio * 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
  }
}
