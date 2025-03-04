import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
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
  String? _gender;
  customerViewModel cvm = customerViewModel();
  bool obscureText = true;
  bool _isLoading = false; // Loading state

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<String> addCustomer() async {
    try {
      return await cvm.addUser(
        birthDate: _date.text,
        email: _email.text,
        gender: _gender ?? "",
        name: _fullName.text,
        password: _password.text,
        phone: _phoneNumber.text,
        username: _email.text,
      );
    } catch (e) {
      return e.toString();
    }
  }

  final List<String> dropDownItems = ["Male", "Female", "Not Prefer To Say"];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = pickedDate.toLocal().toString().split(' ')[0];
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
    _date.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>(); // Add this at the top of your class

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
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
                    MyDropDownMenu(
                      dropDownItems: dropDownItems,
                      prefixIcon: Icons.account_circle_outlined,
                      hintText: "Gender",
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value; // Store the selected gender
                        });
                      },
                    ),

                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    // Birth Date Field with Date Picker
                    MyTextFormField(
                      controller: _date,
                      hintName: "Birth Date",
                      icon: Icons.date_range,
                      onClickFunction:
                          _selectDate, // Passing the function reference
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    // Phone Number Field
                    MyTextFormField(
                      controller: _phoneNumber,
                      hintName: "Phone Number",
                      icon: Icons.phone_outlined,
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    // Email Field
                    MyTextFormField(
                      controller: _email,
                      hintName: "Email",
                      icon: Icons.mail,
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    // Password Field
                    MyTextFormField(
                      controller: _password,
                      hintName: "Password",
                      icon: Icons.lock,
                      isObscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 25 * SizeConfig.textRatio),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    // Sign Up Button
                    customizeButton(
                      buttonName: 'Sign Up',
                      buttonColor: SizeConfig.iconColor,
                      fontColor: Color(0xFFF5F5F5),
                      onClickButton: () async {
                        if (_formKey.currentState!.validate()) { // Validate the form
                          setState(() {
                            _isLoading = true; // Set loading to true
                          });

                          String response = await addCustomer();

                          setState(() {
                            _isLoading = false; // Set loading to false
                          });

                          if (response == "User added successfully") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Sign-Up Successful!")),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Getotp(_email.text, 0), // Instantiate Getotp
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${response}")),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 20),

                    // Other UI elements...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.horizontalBlock * 123,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:
                              const BoxDecoration(color: Color(0xFFD8DADC)),
                        ),
                        Text(
                          "Or With",
                          style: TextStyle(fontSize: SizeConfig.textRatio * 14),
                        ),
                        Container(
                          width: SizeConfig.horizontalBlock * 123,
                          height: SizeConfig.verticalBlock * 2,
                          decoration:
                              const BoxDecoration(color: Color(0xFFD8DADC)),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    customizeButton(
                      buttonName: 'Google',
                      buttonColor: Colors.white,
                      buttonIcon: Icons.mail,
                      fontColor: Colors.black,
                      buttonBorder: Border.all(color: SizeConfig.iconColor),
                    ),
                    SizedBox(height: SizeConfig.verticalBlock * 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style:
                                TextStyle(fontSize: SizeConfig.textRatio * 14)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, logIn.id);
                          },
                          child: Text(
                            'Login',
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
              ),
            ],
          ),
          // Loading overlay
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
}
