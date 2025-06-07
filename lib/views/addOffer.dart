import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/offerModel.dart';
import 'package:gp_frontend/Providers/offerProvider.dart';
import 'package:provider/provider.dart';

import '../Providers/postProvider.dart';
import '../widgets/AppBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/increement_decrement_buttons.dart';
import '../widgets/messages.dart';

class addOffer extends StatelessWidget {
  static String id = "addOffer";
  const addOffer({super.key});

  @override
  Widget build(BuildContext context) {
    final addPostProvider = Provider.of<postProvider>(context);
    offerProvider myOfferProvider = offerProvider();

    Future<bool> submitOffer(
        offerModel offer) async {
      await myOfferProvider.addOffer(offer);
      return true;
    }

    return Scaffold(
        appBar: customAppbar(
          "add Offer",
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        body: ListView(
            children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.horizontalBlock,
              vertical: 5 * SizeConfig.verticalBlock,
            ),
            child: MyTextFormField(
              height: 80 * SizeConfig.verticalBlock,
              width: 350 * SizeConfig.horizontalBlock,
              hintName: "Write here...",
              hintStyle: TextStyle(color: Color(0x503C3C3C)),
              maxLines: 3,
              controller: addPostProvider.description,
              labelText: "Description",
            ),
          ),
              incrementDecrementButtons(
                  "price",
                  "0.00",
                  addPostProvider.price,
                  "ًWrite an estimated price that suits you for the whole."),
              incrementDecrementButtons(
                  "Duration",
                  "0.00",
                  addPostProvider.duration,
                  "Write an estimated time you can wait for the order to be completed."),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: customizeButton(
                    buttonName: "Add Offer",
                    buttonColor: SizeConfig.iconColor,
                    fontColor: Colors.white,
                    onClickButton: () async {

                      if (
                          addPostProvider.description.text.trim().isEmpty ||
                          addPostProvider.price.text.trim().isEmpty ||
                          addPostProvider.duration.text.trim().isEmpty
                        ) {
                        showCustomPopup(
                            context,
                            "Missing!",
                            "Please fill in all fields",
                            []
                        );

                        return;
                      }

                      try {
                        bool success = await submitOffer(
                          offerModel(
                            description: addPostProvider.description.text,
                            price: double.parse(addPostProvider.price.text),
                            duration: int.parse(addPostProvider.duration.text),
                          ),

                        );

                        if (success) {
                          Navigator.pop(context, true);
                        } else {
                          showCustomPopup(
                              context, "offer", "Failed to add offer", []);
                        }
                      } catch (e) {
                        showCustomPopup(context, "offer", "${e.toString()}", []);
                      }
                    }),
              ),

            ]
        )
    );
  }
}
