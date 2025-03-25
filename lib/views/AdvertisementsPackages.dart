import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/AdvertisementProvider.dart';
import 'package:gp_frontend/Providers/BackagesProvider.dart';

import '../widgets/Dimensions.dart';

class Advertisementspackages extends StatefulWidget {
  static String id = "AdvertisementPackages";
  const Advertisementspackages({super.key});

  @override
  State<Advertisementspackages> createState() => _AdvertisementspackagesState();
}

class _AdvertisementspackagesState extends State<Advertisementspackages> {
  BackagesProvider BackVM = BackagesProvider();

  @override
  void initState() {
        BackVM.getAllBackages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight:
        85 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
          'Packages & Pricing',
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
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(15.0 * SizeConfig.verticalBlock),
          child: ListView(
            children: [
              Text("Find the Perfect Plan for You!" , style: GoogleFonts.roboto(fontSize: 32),),
              SizedBox(height: 20 * SizeConfig.verticalBlock,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: BackVM.myBackages.length,
                  itemBuilder: (context , index){
                  return Container(
                    height: 113 * SizeConfig.verticalBlock,
                    width: 360 * SizeConfig.horizontalBlock,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
                      color: Color(0x50E9E9E9),
                    ),
                  );
                  }
              )
            ],
          ),
        ),
      ),

    );
  }
}
