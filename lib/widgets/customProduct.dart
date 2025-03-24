import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import '../Models/ProductModel.dart';
import '../SqfliteCodes/wishList.dart';
import '../views/productDetails.dart';
import 'Dimensions.dart';

class customProduct extends StatefulWidget {
  String imageURL, Name, id;
  double Price, rate;
  bool showCompare;
  int? comparedNum;
  String? Category ;
  final Function(productModel)? onComparePressed;

  customProduct(this.imageURL, this.Name, this.Price, this.rate,
      this.id, this.showCompare,
      {this.onComparePressed, this.comparedNum , this.Category });

  @override
  State<customProduct> createState() => _customProductState(
      this.imageURL,
      this.Name,
      this.Price,
      this.rate,
      this.id,
      this.showCompare,
      onComparePressed: this.onComparePressed,
      comparNum: this.comparedNum,
  Category:this.Category);
}

class _customProductState extends State<customProduct> {
  String imageURL, Name, id;
  double Price, rate;
  wishList wishListObj = wishList();
  bool showCompare;
  int? comparNum;
  String? Category,compareName;
  final Function(productModel)? onComparePressed;
  bool isTapped = true;
  customerViewModel customer = customerViewModel();

  _customProductState(this.imageURL, this.Name, this.Price,
      this.rate, this.id, this.showCompare,
      {this.onComparePressed, this.comparNum , this.Category , this.compareName});



  toggleFavourite(String color) async{
    wishListObj.isWishlistTableEmpty;
    String email = await customer.getEmail();
    setState(() {
      if (color == "${SizeConfig.fontColor}") {
        wishListObj.addProduct('''
            INSERT INTO WISHLIST(ID,EMAIL) 
            VALUES (
                "$id",
                "$email"
             
            )
''');
      } else {
        wishListObj.deleteProduct('''
        DELETE FROM WISHLIST 
        WHERE ID = "$id" AND EMAIL = "$email"
      ''');
      }
    });
    // wishListObj.recreateWishListTable();
  }

  Tapping() {

    if (widget.comparedNum == 2 && isTapped) {

      if (widget.onComparePressed != null) {

        productModel product = productModel(
          widget.id,
          widget.imageURL,
          widget.Name,
          category: widget.Category,
          widget.Price,
          widget.rate,
        );
        widget.onComparePressed!(product);
      }
    } else {
      setState(() {
        isTapped = !isTapped;
      });
      if (widget.onComparePressed != null) {
        productModel product = productModel(
          widget.id,
          widget.imageURL,
          widget.Name,
          category:widget.Category,
          widget.Price,
          widget.rate,
        );
        widget.onComparePressed!(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 170 * SizeConfig.horizontalBlock,
        height: 250 * SizeConfig.verticalBlock,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
            // color: SizeConfig.iconColor,
            border: Border.all(width: 2, color: SizeConfig.iconColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      5 * SizeConfig.textRatio), // Set the border radius
                  child: Image.network(
                    imageURL,
                    width: 160 * SizeConfig.horizontalBlock,
                    height: 165 * SizeConfig.verticalBlock,
                    fit: BoxFit.cover, // Ensures the image fills the space
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                      radius: 15 * SizeConfig.verticalBlock,
                      backgroundColor: Colors.white,
                      child: FutureBuilder<bool>(
                        future: wishListObj
                            .doesIdExist(id), // Call the async function
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          //   // Show a loading indicator while waiting for the result
                          //   return CircularProgressIndicator();
                          // } else
                          if (snapshot.hasError) {
                            // Handle errors
                            return Icon(
                              Icons.favorite,
                              size: 22 * SizeConfig.textRatio,
                              color: SizeConfig.fontColor,
                            );
                          } else {
                            // Use the result (true or false) to determine the color
                            bool exists = snapshot.data ?? false;
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.favorite,
                                size: 22 * SizeConfig.textRatio,
                                color: exists ? Colors.red : SizeConfig.fontColor,
                              ),
                              onPressed: () {
                                toggleFavourite(
                                  exists ? "red" : "${SizeConfig.fontColor}",
                                );
                              },
                            );
                          }
                        },
                      )),
                ),
                if (widget.showCompare)
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        child: Container(
                          width: 75 * SizeConfig.horizontalBlock,
                          height: 32 * SizeConfig.verticalBlock,
                          decoration: BoxDecoration(
                              color: !isTapped
                                  ? SizeConfig.iconColor
                                  : Color(0x50E9E9E9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(child: Text('Compare')),
                        ),
                        onTap: () {
                          Tapping();
                        },
                      ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    Name, // Remember to use quotes around the string
                    style: TextStyle(fontSize: 14 * SizeConfig.textRatio),
                    overflow: TextOverflow.ellipsis, // Optional: handle overflow
                    maxLines: 1, // Optional: limit to one line
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xFFD4931C),
                      size: 10 * SizeConfig.textRatio,
                    ),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text(
                      '${rate}',
                      style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
                    ),
                  ],
                )
              ],
            ),
            Text(
              Category?.isNotEmpty == true ? Category! : "No Category",
              style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${Price}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * SizeConfig.textRatio),
                ),
                Container(
                  width: 30 * SizeConfig.horizontalBlock,
                  height: 24 * SizeConfig.verticalBlock,
                  decoration: BoxDecoration(
                    color: SizeConfig.iconColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 14 * SizeConfig.textRatio,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap:() {
        Navigator.pushNamed(context,productDetails.id , arguments: widget.id);
      },
    );
  }
}
