import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/Providers/AddressProvider.dart';
import 'package:gp_frontend/views/addAddress.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:provider/provider.dart';
import '../widgets/Dimensions.dart';

class chooseAddress extends StatefulWidget {
  static String id = "chooseAddress";
  const chooseAddress({super.key});

  @override
  _chooseAddressState createState() => _chooseAddressState();
}

class _chooseAddressState extends State<chooseAddress> {
  late AddressProvider myAddressProvider;
  int? selectedAddressIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   myAddressProvider = Provider.of<AddressProvider>(context, listen: false);
  //   myAddressProvider.getAddresses();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myAddressProvider = Provider.of<AddressProvider>(context);
    myAddressProvider.getAddresses();
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
        child: Column(
          children: [
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
                  if (addressProvider.addresses.isEmpty) {
                    return const Center(child: Text("No addresses available"));
                  }

                  return ListView.builder(
                    itemCount: addressProvider.addresses.length,
                    itemBuilder: (context, index) {
                      AddressModel address = addressProvider.addresses[index];
                      bool isSelected = index == selectedAddressIndex;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddressIndex = index;
                              });
                            },
                            child: Container(
                              height: 98 * SizeConfig.verticalBlock,
                              width: 345 * SizeConfig.horizontalBlock,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: isSelected ? 2 * SizeConfig.textRatio : 0,
                                  color: isSelected ? SizeConfig.iconColor : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(5 * SizeConfig.horizontalBlock),
                                color: isSelected ? const Color(0xFFE9E9E9) : Colors.transparent,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x25000000),
                                    offset: Offset(1.0, 3.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                  BoxShadow(
                                    color: Color(0xFFE9E9E9),
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 5 * SizeConfig.verticalBlock),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        size: 24 * SizeConfig.textRatio,
                                      ),
                                    ),
                                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address.AddressOwner,
                                          style: GoogleFonts.rubik(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20 * SizeConfig.textRatio,
                                          ),
                                        ),
                                        SizedBox(height: 5 * SizeConfig.verticalBlock),
                                        Text(
                                          "${address.StreetName}, "
                                              "${address.State.isNotEmpty ? '${address.State}, ' : ''}"
                                              "${address.City}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10 * SizeConfig.verticalBlock),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, addAddress.id);
                await myAddressProvider.getAddresses();
                setState(() {});
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
            SizedBox(height: 30 * SizeConfig.verticalBlock),
            customizeButton(
              buttonName: "Apply",
              buttonColor: SizeConfig.iconColor,
              fontColor: Colors.white,
              onClickButton: () {
                if (selectedAddressIndex != null) {
                  AddressModel selectedAddress = myAddressProvider.addresses[selectedAddressIndex!];
                  Navigator.pop(context, selectedAddress);
                } else {
                  print("No address selected");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
