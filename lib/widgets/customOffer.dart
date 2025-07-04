import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/offerModel.dart';
import 'package:gp_frontend/Providers/offerProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/views/addOffer.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:provider/provider.dart';

import '../Models/AddressModel.dart';
import '../views/PaymentScreen.dart';
import '../views/chooseAddress.dart';
import 'Dimensions.dart';

class customOffer extends StatelessWidget {
  final offerModel offer;
  final String clientId;
  final AddressModel? addressData;

  const customOffer({
    super.key,
    required this.offer,
    required this.clientId,
    this.addressData,
  });

  String? _getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    try {
      final uri = Uri.parse(imageUrl);
      if (uri.hasAbsolutePath && !imageUrl.contains('http', 10)) {
        return imageUrl;
      }
    } catch (_) {}
    return null;
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(createdAt);
    if (diff.inHours > 8640) return "${(diff.inHours / 8760).toInt()} yrs";
    if (diff.inHours > 720) return "${(diff.inHours / 720).toInt()} mos";
    if (diff.inHours > 24) return "${(diff.inHours / 24).toInt()} days";
    return "${diff.inHours} hrs";
  }

  Future<bool> _isHandcrafterOwner() async {
    final token = Token();
    final id = await token.getUUID();
    return id == offer.handcrafterId;
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(offer.createdAt ?? "");
    } catch (_) {
      createdAt = DateTime.now();
    }

    final validProfileImageUrl = _getValidImageUrl(offer.profileImage);
    final timeAgo = _getTimeAgo(createdAt);

    return FutureBuilder<bool>(
      future: _isHandcrafterOwner(),
      builder: (context, snapshot) {
        final isOwner = snapshot.data ?? false;

        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                  child: CircleAvatar(
                    backgroundImage: validProfileImageUrl != null
                        ? NetworkImage(validProfileImageUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    radius: 20 * SizeConfig.horizontalBlock,
                    child: validProfileImageUrl == null
                        ? Icon(Icons.person, color: Colors.grey[600], size: 20 * SizeConfig.textRatio)
                        : null,
                  ),
                ),
                SizedBox(width: 10 * SizeConfig.horizontalBlock),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${offer.name}", style: GoogleFonts.roboto(
                        fontSize: 10 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                    Text(timeAgo, style: GoogleFonts.roboto(
                        fontSize: 8 * SizeConfig.textRatio, color: const Color(0x503C3C3C))),
                  ],
                ),
                Spacer(),
                if (isOwner)
                  PopupMenuButton<int>(
                    onSelected: (value) async {
                      if (value == 1) {
                        Navigator.pushNamed(context, addOffer.id, arguments: {
                          'type': 'update',
                          'offer': offer,
                        });
                      } else if (value == 2) {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete offer"),
                            content: const Text("Are you sure you want to delete this offer?"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          final myOfferProvider = Provider.of<offerProvider>(context, listen: false);
                          await myOfferProvider.deleteOffer(offer.id!);
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 1, child: Text("Update offer")),
                      PopupMenuItem(value: 2, child: Text("Delete offer")),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
              ],
            ),
            SizedBox(height: 10 * SizeConfig.verticalBlock),
            Container(
              color: const Color(0x50E9E9E9),
              padding: EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${offer.description}", style: GoogleFonts.roboto(
                      fontSize: 14 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20 * SizeConfig.verticalBlock),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(children: [
                            Text("Price: ", style: GoogleFonts.roboto(
                                fontSize: 12 * SizeConfig.textRatio,
                                color: const Color(0x50000000),
                                fontWeight: FontWeight.bold)),
                            Text("${offer.price} LE", style: GoogleFonts.roboto(
                                fontSize: 12 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                          ]),
                          Row(children: [
                            Text("Duration: ", style: GoogleFonts.roboto(
                                fontSize: 12 * SizeConfig.textRatio,
                                color: const Color(0x50000000),
                                fontWeight: FontWeight.bold)),
                            Text("${offer.duration} days", style: GoogleFonts.roboto(
                                fontSize: 12 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                          ]),
                        ],
                      ),
                      if (clientId == offer.handcrafterId)
                        customizeButton(
                          buttonName: "Confirm",
                          buttonColor: SizeConfig.iconColor,
                          fontColor: Colors.white,
                          height: 30 * SizeConfig.verticalBlock,
                          width: 90 * SizeConfig.horizontalBlock,
                          onClickButton: () async {
                            final selectedAddress = await Navigator.pushNamed(
                                context, chooseAddress.id) as AddressModel;

                            Navigator.pushNamed(context, Paymentscreen.id, arguments: {
                              'type': 'offer',
                              'price': offer.price,
                              'offerId': offer.id,
                              'addressId': selectedAddress.id
                            });
                          },
                        ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            Divider(height: 2 * SizeConfig.verticalBlock),
          ],
        );
      },
    );
  }
}
