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

class addOffer extends StatefulWidget {
  static String id = "addOffer";

  const addOffer({super.key});

  @override
  State<addOffer> createState() => _addOfferState();
}

class _addOfferState extends State<addOffer> {
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      final addPostProvider = Provider.of<postProvider>(context, listen: false);
      final arguments =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final String type = arguments['type'];
      final offerModel? existingOffer =
      type == 'update' ? arguments['offer'] : null;
      // print("offfffffffffffer");
      // print(ar);

      if (type == 'update' && existingOffer != null) {
        addPostProvider.description.text = existingOffer.description ?? '';
        addPostProvider.price.text = existingOffer.price?.toString() ?? '';
        addPostProvider.duration.text = existingOffer.duration?.toString() ?? '';
      }

      isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addPostProvider = Provider.of<postProvider>(context);
    offerProvider myOfferProvider = offerProvider();

    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String type = arguments['type'];
    final String postId =
    type == 'update' ? "": arguments['postId'];
    final offerModel? existingOffer =
    type == 'update' ? arguments['offer'] : null;
    final offer = arguments['offer'];

    Future<bool> submitOffer(offerModel offer) async {
      if (type == 'update' && existingOffer != null) {
        return await myOfferProvider.updateOffer(offer);
      } else {
        return await myOfferProvider.addOffer(offer, postId);
      }
    }

    return Scaffold(
      appBar: customAppbar(
        type == 'update' ? "Update Offer" : "Add Offer",
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
            "Write an estimated price that suits you for the whole.",
          ),
          incrementDecrementButtons(
            "Duration",
            "0.00",
            addPostProvider.duration,
            "Write an estimated time you can wait for the order to be completed.",
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.horizontalBlock,
              vertical: 10 * SizeConfig.verticalBlock,
            ),
            child: customizeButton(
              buttonName: type == 'update' ? "Update Offer" : "Add Offer",
              buttonColor: SizeConfig.iconColor,
              fontColor: Colors.white,
                onClickButton: () async {
                  if (addPostProvider.description.text.trim().isEmpty ||
                      addPostProvider.price.text.trim().isEmpty ||
                      addPostProvider.duration.text.trim().isEmpty) {
                    showCustomPopup(
                      context,
                      "Missing!",
                      "Please fill in all fields",
                      [],
                    );
                    return;
                  }

                  try {
                    bool success;
                    if (type == 'update') {
                      success = await submitOffer(
                        offerModel(
                          description: addPostProvider.description.text,
                          price: double.parse(addPostProvider.price.text),
                          duration: int.parse(addPostProvider.duration.text),
                          id: offer.id,
                          handcrafterId: offer.handcrafterId,
                        ),
                      );
                    } else {
                      success = await submitOffer(
                        offerModel(
                          description: addPostProvider.description.text,
                          price: double.parse(addPostProvider.price.text),
                          duration: int.parse(addPostProvider.duration.text),
                        ),
                      );
                    }

                    if (success) {
                      // ✅ Clear fields after success
                      addPostProvider.description.clear();
                      addPostProvider.price.clear();
                      addPostProvider.duration.clear();

                      Navigator.pop(context, true); // 👈 Pop after clearing
                    } else {
                      showCustomPopup(
                        context,
                        "Offer",
                        "Failed to submit offer",
                        [],
                      );
                    }
                  } catch (e) {
                    showCustomPopup(
                      context,
                      "Offer Error",
                      e.toString(),
                      [],
                    );
                  }
                }

            ),
          ),
        ],
      ),
    );
  }
}
