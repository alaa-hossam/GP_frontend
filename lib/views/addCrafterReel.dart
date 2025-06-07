import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';

class addCrafterReel extends StatefulWidget {
  static String id = "AddCrafterReel";
  const addCrafterReel({super.key});

  @override
  State<addCrafterReel> createState() => _addCrafterReelState();
}

class _addCrafterReelState extends State<addCrafterReel> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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
          'Add Reel',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20 * SizeConfig.verticalBlock),
        child: Column(
          spacing: 10 * SizeConfig.verticalBlock,
          children: [
            Row(
              spacing: 10 * SizeConfig.horizontalBlock,
              children: [
                Container(
                  width: SizeConfig.horizontalBlock * 110,
                  height: SizeConfig.verticalBlock * 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: SizeConfig.iconColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon :Icon(Icons.camera_alt_outlined,size: 40 * SizeConfig.textRatio),onPressed: (){}, ),
                      Text('Camera',style: TextStyle(fontSize: 10 * SizeConfig.textRatio),)
                    ],
                  ),
                ),
                Container(
                  width: SizeConfig.horizontalBlock * 110,
                  height: SizeConfig.verticalBlock * 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: SizeConfig.iconColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon :Icon(Icons.add_box_outlined,size: 40 * SizeConfig.textRatio),onPressed: (){}, ),
                      Text('Drafts',style: TextStyle(fontSize: 10 * SizeConfig.textRatio),)
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recents',style: TextStyle(fontSize: 16 * SizeConfig.textRatio),),
                customizeButton(
                  buttonName: "Next",
                  buttonColor: SizeConfig.iconColor,
                  fontColor: Colors.white,
                  sufixIcon: Icons.arrow_forward,
                  textSize: 18 * SizeConfig.textRatio,
                  width: 90 * SizeConfig.horizontalBlock,
                  height: 40 * SizeConfig.verticalBlock,
                  rad: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
