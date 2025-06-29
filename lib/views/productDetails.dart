import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/SqfliteCodes/cart.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/views/handicrafterProfileClientView.dart';
import 'package:gp_frontend/views/productReviews.dart';
import 'package:gp_frontend/views/variationsDetails.dart';
import '../widgets/Dimensions.dart';

class productDetails extends StatefulWidget {
  static String id = "productScreenDetails";
  const productDetails({super.key});

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  final wishList wishListObj = wishList();
  final Cart cart = Cart();
  final customerViewModel customer = customerViewModel();
  Token token = Token();

  late String email = '';
  late String userId = '';

  @override
  void initState() {
    super.initState();
    _initUserInfo();
  }

  Future<void> _initUserInfo() async {
    email = await token.getEmail()?? "";
    userId = await token.getUUID() ?? "";
    setState(() {}); // To refresh UI once values are loaded
  }

  void toggleFavourite(String productId) async {
    bool exists = await wishListObj.doesIdExist(productId, email);
    if (exists) {
      await wishListObj.deleteProduct(productId, email);
    } else {
      await wishListObj.addProduct(id: productId, email: email);
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as String;
    productProvider productDetails = productProvider();

    return Scaffold(
      body: FutureBuilder(
        future: productDetails.getProductDetails(arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading product details"));
          } else {
            productModel myProduct = productDetails.productDetails;

            return ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                      child: Stack(
                        children: [
                          Container(
                            height: 422 * SizeConfig.verticalBlock,
                            width: 361 * SizeConfig.horizontalBlock,
                            decoration: BoxDecoration(
                              color: SizeConfig.iconColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  myProduct.imageURL,
                                  width: 359 * SizeConfig.horizontalBlock,
                                  height: 420 * SizeConfig.verticalBlock,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            right: 25,
                            child: FutureBuilder<bool>(
                              future: wishListObj.doesIdExist(myProduct.id, email),
                              builder: (context, snapshot) {
                                bool exists = snapshot.data ?? false;
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      size: 25 * SizeConfig.textRatio,
                                      color: exists ? Colors.red : SizeConfig.fontColor,
                                    ),
                                    onPressed: () => toggleFavourite(myProduct.id),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 15,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFD9D9D9),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20 * SizeConfig.textRatio,
                                  color: const Color(0x503C3C3C),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10 * SizeConfig.verticalBlock),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                      child: Container(
                        width: 361 * SizeConfig.horizontalBlock,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * SizeConfig.textRatio),
                          color: const Color(0X50E9E9E9),
                          border: Border.all(color: SizeConfig.iconColor),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0 * SizeConfig.textRatio),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HandcrafterProfileClientView(
                                              handCrafterId: myProduct.handcrafterId!),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.person_outline),
                                        SizedBox(width: 5 * SizeConfig.horizontalBlock),
                                        Text(
                                          '${myProduct.handcrafterName}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12 * SizeConfig.textRatio,
                                            color: const Color(0x703C3C3C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Color(0xFFD4931C)),
                                      SizedBox(width: 5 * SizeConfig.horizontalBlock),
                                      Text("${myProduct.rate}"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                              Text(
                                "${myProduct.name}",
                                style: GoogleFonts.rubik(
                                  fontSize: 24 * SizeConfig.textRatio,
                                  color: const Color(0X80000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                              Text(
                                '${myProduct.description}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14 * SizeConfig.textRatio,
                                  color: const Color(0X50000000),
                                ),
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Productreviews(
                                            reviews: myProduct.reviews ?? [],
                                            rate: myProduct.rate,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.chat, color: SizeConfig.iconColor),
                                  ),
                                  SizedBox(width: 5 * SizeConfig.verticalBlock),
                                  Text(
                                    '${myProduct.ratingCount} Reviews',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14 * SizeConfig.textRatio,
                                      color: const Color(0X50000000),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10 * SizeConfig.verticalBlock),

                    // ✅ Variations + Add to Cart Button
                    variationScreen(myProduct),

                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
