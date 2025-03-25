import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/AdvertisementProvider.dart';
import 'package:gp_frontend/Providers/BackagesProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:provider/provider.dart';

import '../widgets/Dimensions.dart';

class Advertisementspackages extends StatefulWidget {
  static String id = "AdvertisementPackages";
  const Advertisementspackages({super.key});

  @override
  State<Advertisementspackages> createState() => _AdvertisementspackagesState();
}

class _AdvertisementspackagesState extends State<Advertisementspackages> {
  String PackageId = "";

  @override
  void initState() {
    super.initState();
    BackagesProvider BackProvider = Provider.of<BackagesProvider>(context, listen: false);
    BackProvider.getAllBackages();

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
      body: Consumer<BackagesProvider>(
        builder: ( context,packageProvider, child) {
          return        Center(
            child: Padding(
              padding:  EdgeInsets.all(15.0 * SizeConfig.verticalBlock),
              child: ListView(
                children: [
                  Text("Find the Perfect Plan for You!" , style: GoogleFonts.roboto(fontSize: 32),),
                  SizedBox(height: 20 * SizeConfig.verticalBlock,),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: packageProvider.myBackages.length,
                      itemBuilder: (context , index){
                        print(packageProvider.myBackages.length);
                        return Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 113 * SizeConfig.verticalBlock,
                                width: 360 * SizeConfig.horizontalBlock,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
                                  color: Color(0x50E9E9E9),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${packageProvider.myBackages[index].name}" , style: GoogleFonts.roboto(fontSize: 18 * SizeConfig.textRatio ,fontWeight: FontWeight.bold),),
                                          Text("${packageProvider.myBackages[index].description}" , style: GoogleFonts.roboto(fontSize: 10 * SizeConfig.textRatio),),
                                        ],
                                      ),
                                      SizedBox(height: 5 * SizeConfig.verticalBlock),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${packageProvider.myBackages[index].price} LE/day" ,
                                            style: GoogleFonts.roboto(fontSize: 24 * SizeConfig.textRatio ,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: 5 * SizeConfig.verticalBlock),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Duration ${packageProvider.myBackages[index].duration.toInt()} days" ,
                                            style: GoogleFonts.roboto(fontSize: 10 * SizeConfig.textRatio ,fontWeight: FontWeight.bold),)
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),
                              onTap: (){
                                PackageId = packageProvider.myBackages[index].id;
                              },
                            ),
                            SizedBox(height: 10 * SizeConfig.verticalBlock,)
                          ],
                        );
                      }
                  )
                ],
              ),
            ),
          );

        },
      ),

    );
  }
}
