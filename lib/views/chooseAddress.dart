import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gp_frontend/views/addAddress.dart';
import '../widgets/Dimensions.dart';

class chooseAddress extends StatelessWidget {
  static String id = "chooseAddress";
  const chooseAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Rounded bottom-left corner
              bottomRight: Radius.circular(20), // Rounded bottom-right corner
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Delivery Address',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),
      body: SizedBox(
        child: Padding(
          padding:  EdgeInsets.only(left: 10 * SizeConfig.horizontalBlock , right:  10 * SizeConfig.horizontalBlock),
          child: ListView(
            children: [
            Padding(
              padding:  EdgeInsets.only(top: 30 * SizeConfig.verticalBlock),
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, addAddress.id);
                  },
                  child: DottedBorder(
                  color: Color(0x503C3C3C),
                  strokeWidth: 1 * SizeConfig.verticalBlock,
                  dashPattern: [6, 3], // 6 pixels line, 3 pixels gap
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  child: Container(
                    width: 345 * SizeConfig.horizontalBlock,
                    height: 68 * SizeConfig.verticalBlock,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: SizeConfig.secondColor,
                          child: Icon(Icons.add , size: 24* SizeConfig.textRatio, color: Colors.white,),
                        ),
                        SizedBox(width: 10* SizeConfig.horizontalBlock,),
                        Text("Add new address" , style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.textRatio),)
                      ],
                    ),
                  ),
                            ),
                ),
              ),
            )

            ],
          ),
        ),
      ),

    );
  }
}
