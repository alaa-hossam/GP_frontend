import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/confirmOrder.dart';
import 'package:gp_frontend/widgets/cartAppBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gp_frontend/widgets/messages.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import 'chooseAddress.dart';

class checkOut extends StatefulWidget {
  static String id = "checkOut";
  const checkOut({super.key});

  @override
  State<checkOut> createState() => _checkOutState();
}




class _checkOutState extends State<checkOut> {
  late String voucher;
  late double price;
  late int percentage;
  late List<productModel> products;
  late String type;
  int? selectedPaymentIndex;
  AddressModel? addressData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    voucher = args?['voucher'] ?? '';
    price = args?['price']?.toDouble() ?? 0.0;
    percentage = args?['percentage'] ?? 0;
    products = args?['products'] ?? [];
    type = args?['type'] ?? '';
  }

  Widget buildPaymentMethod({
    required int index,
    required String assetPath,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        width: 358 * SizeConfig.horizontalBlock,
        height: 80 * SizeConfig.verticalBlock,
        decoration: BoxDecoration(
          color: const Color(0x50E9E9E9),
          borderRadius:
          BorderRadius.circular(5 * SizeConfig.horizontalBlock),
          border: Border.all(
              color: SizeConfig.iconColor, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20 * SizeConfig.horizontalBlock,
                height: 20 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                  border: Border.all(width: 2 * SizeConfig.horizontalBlock),
                  borderRadius:
                  BorderRadius.circular(10 * SizeConfig.textRatio),
                ),
                child: CircleAvatar(
                  backgroundColor: selectedPaymentIndex == index
                      ? SizeConfig.iconColor
                      : Colors.transparent,
                ),
              ),
              SizedBox(width: 10 * SizeConfig.horizontalBlock),
              Image.asset(
                assetPath,
                width: 93 * SizeConfig.horizontalBlock,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToChooseAddress(BuildContext context) async {
    final selectedAddress = await Navigator.pushNamed(
      context,
      chooseAddress.id,
    );

    if (selectedAddress != null) {

      setState(() {
        addressData =  selectedAddress as AddressModel;
      });

      print("Selected Address: $addressData");
    } else {
      print("No address selected");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 185 * SizeConfig.verticalBlock,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new),
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 100 * SizeConfig.horizontalBlock),
                        child: Text(
                          "My Cart",
                          style: GoogleFonts.rubik(
                              fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CartBar(
                          icon: Icons.shopping_cart_outlined,
                          step: "step 1",
                          label: "View Cart"),
                      Container(
                        width: 50 * SizeConfig.horizontalBlock,
                        height: 4 * SizeConfig.verticalBlock,
                        color: const Color(0x50E9E9E9),
                      ),
                      CartBar(
                          icon: Icons.list, step: "step 2", label: "Check Out"),
                      Container(
                        width: 50 * SizeConfig.horizontalBlock,
                        height: 4 * SizeConfig.verticalBlock,
                        color: const Color(0x50E9E9E9),
                      ),
                      CartBar(
                          icon: Icons.checklist,
                          step: "step 3",
                          label: "Order review",
                          disabled: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text("Delivery address",
                        style: GoogleFonts.rubik(
                            fontSize: 20 * SizeConfig.textRatio)),
                    GestureDetector(
                      onTap: () {
                        navigateToChooseAddress(context);
                      },
                      child: Container(
                        width: 358 * SizeConfig.horizontalBlock,
                        height: 80 * SizeConfig.verticalBlock,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0x50E9E9E9),
                          borderRadius: BorderRadius.circular(
                              5 * SizeConfig.horizontalBlock),
                          border: Border.all(
                              color: SizeConfig.iconColor, width: 1),
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.location_on_outlined,
                                    color: Color(0xFF292929),
                                    size: 22 * SizeConfig.textRatio),
                                SizedBox(
                                    width: 10 * SizeConfig.horizontalBlock),
                                Text(
                                    addressData != null ?
                                    "${addressData!.StreetName} ,"
                                        " ${addressData!.State != "" ?addressData!.State + ",":""}"
                                        " ${addressData!.City}":
                                    "Choose Address",
                                    style: GoogleFonts.roboto(
                                        fontSize: 20 * SizeConfig.textRatio,
                                        color: Color(0x503C3C3C))),
                              ]),
                              Icon(Icons.arrow_forward_ios,
                                  color: Color(0xFF292929),
                                  size: 22 * SizeConfig.textRatio),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text("Payment method",
                        style: GoogleFonts.rubik(
                            fontSize: 20 * SizeConfig.textRatio)),
                    buildPaymentMethod(
                        index: 0, assetPath: "assets/images/visa.png"),
                    buildPaymentMethod(
                        index: 1, assetPath: "assets/images/cash.png"),
                    if (voucher.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            color: Color(0x50E9E9E9),
                            width: 358 * SizeConfig.horizontalBlock,
                            height: 60 * SizeConfig.verticalBlock,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: 10 * SizeConfig.horizontalBlock),
                            child: Text(voucher,
                                style: GoogleFonts.rubik(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:  EdgeInsets.only(left:20 * SizeConfig.horizontalBlock,
                                right:20 * SizeConfig.horizontalBlock),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Price:",
                                    style: GoogleFonts.rubik(
                                        fontSize: 24 * SizeConfig.textRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x70000000)
                                    )
                                ),
                                Text(type.toLowerCase() == "amount"?
                                    "${price - percentage} LE":
                                    "${price - (price * percentage)}",
                                    style: GoogleFonts.rubik(
                                        fontSize: 24 * SizeConfig.textRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x70000000)
                                    )
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.only(left:20 * SizeConfig.horizontalBlock,
                                right:20 * SizeConfig.horizontalBlock),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discount:",
                                    style: GoogleFonts.rubik(
                                        fontSize: 24 * SizeConfig.textRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x70000000)
                                    )
                                ),
                                Text(type.toLowerCase() == "amount"?
                                "${percentage} LE":
                                "${percentage} %",
                                    style: GoogleFonts.rubik(
                                        fontSize: 24 * SizeConfig.textRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x70000000)
                                    )
                                ),

                              ],
                            ),
                          ),

                          Divider(thickness: 1, color: Colors.grey),
                        ],
                      )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Total Price",
                      style: GoogleFonts.rubik(
                          fontSize: 24 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold)),
                  Text('LE ${price.toStringAsFixed(2)}',
                      style: GoogleFonts.rubik(
                          fontSize: 24 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.0 * SizeConfig.verticalBlock),
                child: customizeButton(
                  buttonColor: SizeConfig.iconColor,
                  buttonName: "Continue",
                  fontColor: Colors.white,
                  width: 370 * SizeConfig.horizontalBlock,
                  height: 50 * SizeConfig.verticalBlock,
                  onClickButton: () async{
                    if (selectedPaymentIndex == null) {
                      await showCustomPopup(context, "Missing", "Please select a payment method", []);
                      return;
                    }if (addressData == null) {
                      await showCustomPopup(context, "Missing", "Please select an Address" , []);

                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      confirmOrder.id,
                      arguments: {
                        "products": products,
                        "price":price.toInt(),
                        "payment":selectedPaymentIndex == 0 ?"assets/images/visa.png" :"assets/images/cash.png",
                        "address": addressData
                      }
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
