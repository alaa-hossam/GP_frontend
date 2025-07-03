import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/addFinalProduct.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../widgets/customizeButton.dart';
import '../widgets/messages.dart';
import '../widgets/customizeFinalProduct.dart';
import 'MyHandcrafterProfile.dart';

class FinalProduct extends StatefulWidget {
  static String id = "AddFinalProductScreen";
  final productModel product;

  const FinalProduct({super.key, required this.product});

  @override
  State<FinalProduct> createState() => _FinalProductState();
}

class _FinalProductState extends State<FinalProduct> {

  String? extractSize(Map<String, dynamic> finalProduct) {
    final variations = finalProduct['finalProductVariation'] as List<dynamic>?;

    if (variations != null) {
      for (var v in variations) {
        final type = v['productVariation']['variationType'];
        final value = v['productVariation']['variationValue'];
        if (type == 'size') {
          return value;
        }
      }
    }
    return null;
  }

  String? extractMaterial(Map<String, dynamic> finalProduct) {
    final variations = finalProduct['finalProductVariation'] as List<dynamic>?;

    if (variations != null) {
      for (var v in variations) {
        final type = v['productVariation']['variationType'];
        final value = v['productVariation']['variationValue'];
        if (type == 'material') {
          return value;
        }
      }
    }
    return null;
  }

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Final Products',
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
          horizontal: 15 * SizeConfig.horizontalBlock,
          vertical: 10 * SizeConfig.verticalBlock,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.product.finalProducts == null ||
                widget.product.finalProducts!.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "There are no final products yet.",
                    style: TextStyle(
                      fontSize: 24 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rubik",
                      color: const Color(0xFF3C3C3C).withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: widget.product.finalProducts?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = widget.product.finalProducts![index];

                    final Map<String, dynamic> variationMap = {};
                    final variations = item['finalProductVariation'];
                    if (variations != null) {
                      for (var variation in variations) {
                        final productVariation = variation['productVariation'];
                        if (productVariation != null) {
                          variationMap[productVariation['variationType']] = productVariation['variationValue'];
                        }
                      }
                    }
                    return CustomizeFinalProduct(
                      item['imageUrl'] ?? '',
                      item['customPrice']?.toDouble() ?? 0.0,
                      item['id'] ?? '',
                      quantity: item['stockQuantity']?.toDouble(),
                      duration: item['duration']?.toDouble(),
                      variations: variationMap,
                    );
                  },
                ),
              ),
            SizedBox(height: 10 * SizeConfig.verticalBlock),
            Column(
              spacing: 30 * SizeConfig.verticalBlock,
              children: [
                GestureDetector(
                  onTap: (){
                    if (widget.product.variationsWithIds != null &&
                        widget.product.variationsWithIds!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFinalProduct(
                            widget.product.id,
                            variations: widget.product.variations,
                          ),
                        ),
                      );

                    } else {
                      showCustomPopup(
                        context,
                        "Missing Data",
                        "No variations found for this product.",
                        [],
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: SizeConfig.horizontalBlock * 20,
                        backgroundColor: SizeConfig.secondColor,
                        foregroundColor: Colors.white,
                        child:  Icon(Icons.add,
                              size: SizeConfig.horizontalBlock * 20),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add final product",
                        style: TextStyle(
                          fontSize: 20 * SizeConfig.textRatio,
                          fontFamily: "Roboto",
                        ),
                      ),

                    ],
                  ),
                ),
                Center(
                  child: customizeButton(
                    buttonName: 'Finish',
                    buttonColor: const Color(0xFF5095B0),
                    fontColor: const Color(0xFFF5F5F5),
                    width: 200 * SizeConfig.horizontalBlock,
                    height: 50 * SizeConfig.verticalBlock,
                    onClickButton: () async {
                      loadProfileByRole(
                        context: context,
                        onCustomerLoaded: (customer) {
                          print("Customer loaded: ${customer.name}");
                        },
                        onCrafterLoaded: (crafter) {
                          Navigator.pop(context);

                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
