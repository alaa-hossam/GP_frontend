import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:provider/provider.dart';
import '../Models/ProductModel.dart';
import '../SqfliteCodes/wishList.dart';
import '../views/productDetails.dart';
import 'Dimensions.dart';

class customProduct extends StatefulWidget {
  final String imageURL, Name, id;
  final double Price, rate;
  final bool showCompare;
  final int? comparedNum;
  final String? Category;
  final Function(productModel)? onComparePressed;

  const customProduct(this.imageURL, this.Name, this.Price, this.rate, this.id, this.showCompare,
      {this.onComparePressed, this.comparedNum, this.Category, super.key});

  @override
  State<customProduct> createState() => _customProductState();
}

class _customProductState extends State<customProduct> {
  final wishList wishListObj = wishList();
  final Token myToken = Token();

  bool isTapped = true;
  bool isFavorite = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmailAndFavorite();
  }

  Future<void> _loadEmailAndFavorite() async {
    email = await myToken.getEmail() ?? "";
    final exists = await wishListObj.doesIdExist(widget.id, email);
    if (mounted) {
      setState(() {
        isFavorite = exists;
      });
    }
  }

  Future<void> toggleFavourite() async {
    if (isFavorite) {
      await wishListObj.deleteProduct(widget.id, email);
    } else {
      await wishListObj.addProduct(id: widget.id, email: email);
      print(await wishListObj.getProductIdsByEmail(email));
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _handleCompareTap() {
    if (widget.comparedNum == 2 && isTapped) {
      _sendProductToCompare();
    } else {
      setState(() {
        isTapped = !isTapped;
      });
      _sendProductToCompare();
    }
  }

  void _sendProductToCompare() {
    if (widget.onComparePressed != null) {
      final product = productModel(
        widget.id,
        widget.imageURL,
        widget.Name,
        category: widget.Category,
        widget.Price,
        widget.rate,
      );
      widget.onComparePressed!(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, productDetails.id, arguments: widget.id);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 170 * SizeConfig.horizontalBlock,
        height: 250 * SizeConfig.verticalBlock,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5 * SizeConfig.textRatio),
          border: Border.all(width: 2, color: SizeConfig.iconColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5 * SizeConfig.textRatio),
                  child: Image.network(
                    widget.imageURL,
                    width: 160 * SizeConfig.horizontalBlock,
                    height: 165 * SizeConfig.verticalBlock,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite,
                        size: 25 * SizeConfig.textRatio,
                        color: isFavorite ? Colors.red : SizeConfig.fontColor,
                      ),
                      onPressed: toggleFavourite,
                    ),
                  ),
                ),
                if (widget.showCompare)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: _handleCompareTap,
                      child: Container(
                        width: 75 * SizeConfig.horizontalBlock,
                        height: 32 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          color: isTapped ? const Color(0x50E9E9E9) : SizeConfig.iconColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Text('Compare')),
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.Name,
                    style: TextStyle(fontSize: 14 * SizeConfig.textRatio),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xFFD4931C),
                      size: 10 * SizeConfig.textRatio,
                    ),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text(
                      '${widget.rate}',
                      style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              widget.Category?.isNotEmpty == true ? widget.Category! : "No Category",
              style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.Price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * SizeConfig.textRatio,
                  ),
                ),
                Container(
                  width: 30 * SizeConfig.horizontalBlock,
                  height: 24 * SizeConfig.verticalBlock,
                  decoration: BoxDecoration(
                    color: SizeConfig.iconColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
