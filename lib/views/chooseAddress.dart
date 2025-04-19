import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gp_frontend/Providers/AddressProvider.dart';
import 'package:gp_frontend/views/addAddress.dart';
import 'package:provider/provider.dart';
import '../widgets/Dimensions.dart';

class chooseAddress extends StatefulWidget {
  static String id = "chooseAddress";
  chooseAddress({super.key});

  @override
  _chooseAddressState createState() => _chooseAddressState();
}

class _chooseAddressState extends State<chooseAddress> {
  late AddressProvider myAddressProvider;

  @override
  void initState() {
    super.initState();

    // Defer the call to ensure context is available
      myAddressProvider = Provider.of<AddressProvider>(context, listen: false);
      myAddressProvider.getAddresses(); // Fetch addresses on initialization
  }

  @override
  Widget build(BuildContext context) {
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
          'Delivery Address',
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
      body: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10 * SizeConfig.horizontalBlock,
            right: 10 * SizeConfig.horizontalBlock,
            top: 10 * SizeConfig.verticalBlock,
          ),
          child: Column(
            children: [
              if (myAddressProvider.addresses.isNotEmpty)
                SizedBox(
                  height: 550 * SizeConfig.verticalBlock,
                  child:ListView.builder(
                    itemCount: myAddressProvider.addresses.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            height: 98 * SizeConfig.verticalBlock,
                            width: 345 * SizeConfig.horizontalBlock,
                            decoration: BoxDecoration(
                              color: Color(0x50E9E9E9),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5 * SizeConfig.horizontalBlock),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE9E9E9), // Soft light glow
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset(0, 0), // Centered shadow for outer glow
                                ),
                              ],

                            ),
                          ),
                          SizedBox(height: 5 * SizeConfig.verticalBlock),

                        ],
                      );
                    },
                  )
                ),

              Padding(
                padding: EdgeInsets.only(top: 30 * SizeConfig.verticalBlock),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, addAddress.id);
                    },
                    child: DottedBorder(
                      color: Color(0x503C3C3C),
                      strokeWidth: 1 * SizeConfig.verticalBlock,
                      dashPattern: [6, 3],
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
                              child: Icon(
                                Icons.add,
                                size: 24 * SizeConfig.textRatio,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10 * SizeConfig.horizontalBlock,
                            ),
                            Text(
                              "Add new address",
                              style: GoogleFonts.roboto(
                                fontSize: 20 * SizeConfig.textRatio,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}