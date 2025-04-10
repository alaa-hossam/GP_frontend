import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/showBazar.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:provider/provider.dart';

import '../Providers/BazarProvider.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import 'Home.dart';

class BazarReview extends StatefulWidget {
  static String id = "BazarReviewScreen";
  const BazarReview({super.key});

  @override
  State<BazarReview> createState() => _BazarReviewState();
}

class _BazarReviewState extends State<BazarReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 85 * SizeConfig.verticalBlock,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
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
            icon: Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: SizeConfig.textRatio * 15),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Review',
            style: GoogleFonts.rubik(
                color: Colors.white, fontSize: 20 * SizeConfig.textRatio),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
        body: Consumer<BazarProvider>(builder: (builder, bazarProvider, child) {
          return ListView.builder(
              itemCount: bazarProvider.myProducts.length,
              itemBuilder: (builder, index) {
                var product = bazarProvider.myProducts[index];
                return Padding(
                  padding:  EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5 * SizeConfig.horizontalBlock),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: SizeConfig.iconColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // soft black shadow
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: Offset(0, 3), // moves the shadow down
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
                              child: Image.network(
                                product.imageURL ?? '',
                                width: 100 * SizeConfig.horizontalBlock,
                                height: 100 * SizeConfig.verticalBlock,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name ?? '',
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(product.category ?? '',
                                      style: const TextStyle(color: Colors.grey)),
                                  Text("${product.price ?? 0} EGP",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10 * SizeConfig.verticalBlock,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Offer" , style: GoogleFonts.roboto(fontSize:  20 * SizeConfig.textRatio),),

                              Container(
                                height: 50 * SizeConfig.verticalBlock,
                                width: 160 * SizeConfig.horizontalBlock,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
                                    color: Color(0x50E9E9E9),
                                    border: Border.all(color: SizeConfig.iconColor , width: 1 * SizeConfig.horizontalBlock)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5 * SizeConfig.horizontalBlock,),
                                    Text("${bazarProvider.getOffer(product.id)}" ,
                                      style: TextStyle(color: Colors.grey , fontSize: 20 * SizeConfig.textRatio),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text("Quantity" , style: GoogleFonts.roboto(fontSize:  20 * SizeConfig.textRatio),),

                              Container(
                                height: 50 * SizeConfig.verticalBlock,
                                width: 160 * SizeConfig.horizontalBlock,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
                                    color: Color(0x50E9E9E9),
                                    border: Border.all(color: SizeConfig.iconColor , width: 1 * SizeConfig.horizontalBlock)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5 * SizeConfig.horizontalBlock,),
                                    Text("${bazarProvider.getTotalQuantityForProduct(product.id)}" ,
                                      style: TextStyle(color: Colors.grey , fontSize: 20 * SizeConfig.textRatio),),
                                  ],
                                ),
                              )
                            ],
                          ),

                        ],
                      ),

                      SizedBox(
                        height: 15 * SizeConfig.verticalBlock,
                      ),
                      index != bazarProvider.myProducts.length - 1
                          ? Container(
                        height: 2 * SizeConfig.verticalBlock,
                        width: 285 * SizeConfig.horizontalBlock,
                        color: Colors.grey,
                      )
                          : customizeButton(buttonColor: SizeConfig.iconColor,
                        buttonName: "Finish",fontColor: Colors.white,width: 175 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,onClickButton: (){
                            Navigator.pushNamedAndRemoveUntil(context, showBazar.id ,ModalRoute.withName('/Home'),  );
                        },),

                    ],
                  ),
                );
              });
        }));
  }
}
