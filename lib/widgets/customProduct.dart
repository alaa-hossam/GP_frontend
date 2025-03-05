import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Dimensions.dart';

class customProduct extends StatefulWidget {
  String imageURL, Name, Category;
  int Price, rate;

  customProduct(this.imageURL, this.Name, this.Category, this.Price, this.rate);

  @override
  State<customProduct> createState() => _customProductState(
      this.imageURL, this.Name, this.Category, this.Price, this.rate);
}

class _customProductState extends State<customProduct> {
  bool isFav = false;
  String imageURL, Name, Category;
  int Price, rate;

  _customProductState(
      this.imageURL, this.Name, this.Category, this.Price, this.rate);

  toggleFavourite() {
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite,
                        size: 22 * SizeConfig.textRatio,
                        color: isFav ? Colors.red : SizeConfig.fontColor,
                      ),
                      onPressed: () {
                        toggleFavourite();
                      },
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Name,
                style: TextStyle(fontSize: 14 * SizeConfig.textRatio),
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
            Category,
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
                  child:Icon(Icons.add , size: 14* SizeConfig.textRatio, color: Colors.white,),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
