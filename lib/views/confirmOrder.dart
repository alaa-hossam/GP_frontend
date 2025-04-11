import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/PaymentScreen.dart';

import '../Models/ProductModel.dart';
import '../widgets/Dimensions.dart';
import '../widgets/cartAppBar.dart';
import '../widgets/customizeButton.dart';
import 'chooseAddress.dart';

class confirmOrder extends StatefulWidget {
  static String id = "confirmOrder";
  const confirmOrder({super.key});

  @override
  State<confirmOrder> createState() => _confirmOrderState();
}

class _confirmOrderState extends State<confirmOrder> {
  late String payment;
  late double price;
  late List<productModel> products;
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    payment = args?['payment'] ?? '';
    price = args?['price']?.toDouble() ?? 0.0;
    products = args?['products'] ?? [];
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
                          label: "Order review"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
          child: ListView(
            children: [
              Text("Delivery address",
                  style:
                      GoogleFonts.rubik(fontSize: 20 * SizeConfig.textRatio)),
              Container(
                width: 358 * SizeConfig.horizontalBlock,
                height: 80 * SizeConfig.verticalBlock,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.horizontalBlock),
                  border: Border.all(color: SizeConfig.iconColor, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.location_on_outlined,
                            color: Color(0xFF292929),
                            size: 22 * SizeConfig.textRatio),
                        SizedBox(width: 10 * SizeConfig.horizontalBlock),
                        Text("Choose Address",
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
              Text("Payment method",
                  style:
                      GoogleFonts.rubik(fontSize: 20 * SizeConfig.textRatio)),
              Container(
                width: 358 * SizeConfig.horizontalBlock,
                height: 80 * SizeConfig.verticalBlock,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.horizontalBlock),
                  border: Border.all(color: SizeConfig.iconColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 130 * SizeConfig.horizontalBlock,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10 * SizeConfig.horizontalBlock)),
                        child: Image.asset(
                          payment,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("Order List",
                  style:
                      GoogleFonts.rubik(fontSize: 20 * SizeConfig.textRatio)),
              SizedBox(
                  height: 200 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (contex, index) {
                        return Column(
                          children: [
                            Container(
                                width: 358 * SizeConfig.horizontalBlock,
                                height: 150 * SizeConfig.verticalBlock,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color(0x50E9E9E9),
                                  border: Border.all(
                                      width: 2, color: SizeConfig.iconColor),
                                ),
                                child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            5.0 * SizeConfig.verticalBlock),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Image.network(
                                            products[index].imageURL,
                                            width: 140 *
                                                SizeConfig.horizontalBlock,
                                            height:
                                                140 * SizeConfig.verticalBlock,
                                            fit: BoxFit
                                                .cover, // Ensures the image fills the space
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 10 * SizeConfig.verticalBlock,
                                          // bottom: 10 * SizeConfig.verticalBlock,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              products[index].name,
                                              style: GoogleFonts.roboto(
                                                  fontSize:
                                                      16 * SizeConfig.textRatio,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              products[index].category!,
                                              style: GoogleFonts.rubik(
                                                fontSize:
                                                    11 * SizeConfig.textRatio,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0x50000000),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 80 *
                                                  SizeConfig.horizontalBlock,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: products[index]
                                                          .variations
                                                          ?.length ??
                                                      0,
                                                  itemBuilder: (context, i) {
                                                    final product =
                                                        products[index];
                                                    final variations =
                                                        product.variations;
                                                    print(index);
                                                    print(
                                                        products[i].variations);
                                                    if (variations != null &&
                                                        variations.isNotEmpty &&
                                                        i < variations.length) {
                                                      final variation =
                                                          variations[i];

                                                      final variationType =
                                                          variation?['productVariation']
                                                                  ?[
                                                                  'variationType'] ??
                                                              'N/A';
                                                      final variationValue =
                                                          variation?['productVariation']
                                                                  ?[
                                                                  'variationValue'] ??
                                                              'N/A';

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            variationType +
                                                                ":" +
                                                                variationValue,
                                                            style: GoogleFonts.roboto(
                                                                color: Color(
                                                                    0x50000000),
                                                                fontSize: 12 *
                                                                    SizeConfig
                                                                        .textRatio),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  }),
                                            ),
                                            SizedBox(
                                              height:
                                                  20 * SizeConfig.verticalBlock,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${products[index].price * products[index].Quantity!} EG',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 20 *
                                                          SizeConfig.textRatio,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 15 *
                                                      SizeConfig
                                                          .horizontalBlock,
                                                ),
                                                Container(
                                                  width: 78 *
                                                      SizeConfig
                                                          .horizontalBlock,
                                                  height: 42 *
                                                      SizeConfig.verticalBlock,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: SizeConfig
                                                              .iconColor,
                                                          width: 1),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(5 *
                                                              SizeConfig
                                                                  .textRatio))),
                                                  child: Center(
                                                    child: Text(
                                                      "${products[index].Quantity}",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20 *
                                                              SizeConfig
                                                                  .textRatio , fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                          ],
                        );
                      })),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20.0 * SizeConfig.verticalBlock),
                child: customizeButton(
                  buttonColor: SizeConfig.iconColor,
                  buttonName: "Confirm Order",
                  fontColor: Colors.white,
                  width: 370 * SizeConfig.horizontalBlock,
                  height: 50 * SizeConfig.verticalBlock,
                  onClickButton: () {
                    Navigator.pushNamed(context, Paymentscreen.id, arguments:
                      price);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
