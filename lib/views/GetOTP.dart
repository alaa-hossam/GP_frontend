import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/Dimensions.dart';

class Getotp extends StatefulWidget {
  static String id = "GetOtpScreen";
  const Getotp({super.key});

  @override
  State<Getotp> createState() => _GetotpState();
}

class _GetotpState extends State<Getotp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                        'Please enter the 5 digit code sent to your email.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0x803C3C3C),
                          fontSize: SizeConfig.textRatio * 16,
                          fontFamily: 'caption-regular',
                        ),
                      ),
                    ],

                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
