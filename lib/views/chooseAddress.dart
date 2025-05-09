import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/Providers/AddressProvider.dart';
import 'package:gp_frontend/views/addAddress.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import '../widgets/Dimensions.dart';
import '../widgets/addressContainer.dart';

class chooseAddress extends StatefulWidget {
  static String id = "chooseAddress";
  const chooseAddress({super.key});

  @override
  _chooseAddressState createState() => _chooseAddressState();
}

class _chooseAddressState extends State<chooseAddress> {
  ValueNotifier<int?> selectedAddressIndexNotifier = ValueNotifier<int?>(null);
  AddressProvider myAddressProvider = AddressProvider();
  List<AddressModel> addresses = [];

  // Function to get addresses
  getAddresses() async {
    await myAddressProvider.getAddresses();
    addresses = myAddressProvider.addresses;
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
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Delivery Address',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10 * SizeConfig.horizontalBlock,
          vertical: 10 * SizeConfig.verticalBlock,
        ),
        child: FutureBuilder(
          future: getAddresses(),
          builder: (context, snapshot) {
            // Show loading state
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Text(
                  "Loading...",
                  style: GoogleFonts.rubik(
                    fontSize: 20 * SizeConfig.textRatio,
                    color: Color(0x503C3C3C),
                  ),
                ),
              );
            } else if (addresses.isEmpty) {
              // Show message if no addresses are available
              return Stack(
                children: [
                  Center(
                    child: Text(
                      "You have not posted anything yet.",
                      style: GoogleFonts.rubik(
                        fontSize: 20 * SizeConfig.textRatio,
                        color: Color(0x503C3C3C),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15 * SizeConfig.verticalBlock,
                    right: 15 * SizeConfig.horizontalBlock,
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: SizeConfig.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(25 * SizeConfig.textRatio)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, addAddress.id);
                        },
                        icon: Icon(
                          Icons.add,
                          size: 30 * SizeConfig.textRatio,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder<int?>(
                    valueListenable: selectedAddressIndexNotifier,
                    builder: (context, selectedIndex, child) {
                      return ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          AddressModel address = addresses[index];
                          bool isSelected = index == selectedIndex;

                          return Column(
                            children: [
                              AddressItem(
                                address: address,
                                isSelected: isSelected,
                                onTap: () {
                                  selectedAddressIndexNotifier.value = index;
                                },
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10 * SizeConfig.verticalBlock),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, addAddress.id);
                    if (result == true) {
                      setState(() {
                        // Refresh addresses after adding new one
                        getAddresses();
                      });
                    }
                  },
                  child: DottedBorder(
                    color: const Color(0x503C3C3C),
                    strokeWidth: 1 * SizeConfig.verticalBlock,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
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
                          SizedBox(width: 10 * SizeConfig.horizontalBlock),
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
                SizedBox(height: 10 * SizeConfig.verticalBlock),
                customizeButton(
                  buttonName: "Apply",
                  buttonColor: SizeConfig.iconColor,
                  fontColor: Colors.white,
                  onClickButton: () {
                    if (selectedAddressIndexNotifier.value != null) {
                      AddressModel selectedAddress = addresses[selectedAddressIndexNotifier.value!];
                      Navigator.pop(context, selectedAddress);
                    } else {
                      print("No address selected");
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
