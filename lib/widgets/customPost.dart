import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/views/offers.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class customPost extends StatelessWidget {
  final postModel post;

  const customPost(this.post, {Key? key}) : super(key: key);

  String _getTimeAgo(DateTime createdAt) {
    DateTime now = DateTime.now().toUtc();
    Duration difference = now.difference(createdAt);

    if (difference.inHours > 8640) {
      int years = (difference.inHours / 8760).toInt();
      return "$years yrs";
    } else if (difference.inHours > 720) {
      int months = (difference.inHours / 720).toInt();
      return "$months mos";
    } else if (difference.inHours > 24) {
      int days = (difference.inHours / 24).toInt();
      return "$days days";
    } else {
      return "${difference.inHours} hrs";
    }
  }

  String? _getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(imageUrl);
      if (uri.hasAbsolutePath && !imageUrl.contains('http', 10)) {
        return imageUrl;
      } else {
        print("Invalid image URL detected: $imageUrl");
        return null;
      }
    } catch (e) {
      print("Failed to parse image URL: $imageUrl");
      return null;
    }
  }

  void _handleMenuSelection(int value) {
    print("Selected option: $value");
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(post.createdAt ?? "");
    } catch (e) {
      createdAt = DateTime.now();
    }

    final String timeAgo = _getTimeAgo(createdAt);
    final String? validImageUrl = _getValidImageUrl(post.postImage);
    final String? validProfileImageUrl = _getValidImageUrl(post.clientImage);

    return Container(
      width: 385 * SizeConfig.horizontalBlock,
      decoration: BoxDecoration(
        color: const Color(0x50E9E9E9),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: SizeConfig.iconColor),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0 * SizeConfig.verticalBlock),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info + Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (validProfileImageUrl != null)
                        Padding(
                          padding:
                          EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                          child: CircleAvatar(
                            backgroundImage:
                            NetworkImage(validProfileImageUrl),
                            backgroundColor: Colors.transparent,
                            radius: 20 * SizeConfig.horizontalBlock,
                          ),
                        )
                      else
                        Padding(
                          padding:
                          EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 20 * SizeConfig.horizontalBlock,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: 20 * SizeConfig.textRatio,
                            ),
                          ),
                        ),
                      SizedBox(width: 10 * SizeConfig.horizontalBlock),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${post.userName}",
                            style: GoogleFonts.roboto(
                                fontSize: 10 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            timeAgo,
                            style: GoogleFonts.roboto(
                                fontSize: 8 * SizeConfig.textRatio,
                                color: const Color(0x503C3C3C)),
                          ),
                        ],
                      )
                    ],
                  ),
                  PopupMenuButton<int>(
                    onSelected: _handleMenuSelection,
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem(value: 1, child: Text("Option 1")),
                      PopupMenuItem(value: 2, child: Text("Option 2")),
                      PopupMenuItem(value: 3, child: Text("Option 3")),
                    ],
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * SizeConfig.horizontalBlock),
                child: Text("${post.title}",
                    style: GoogleFonts.roboto(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 10 * SizeConfig.verticalBlock,
              ),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 15 * SizeConfig.horizontalBlock),
                child: Text("${post.description}"),
              ),

              // Price, Duration, Quantity
              Padding(
                padding: EdgeInsets.only(
                  left: 40.0 * SizeConfig.horizontalBlock,
                  top: 10 * SizeConfig.verticalBlock,
                  bottom: 10 * SizeConfig.verticalBlock,
                ),
                child: Row(
                  children: [
                    Text("Price:",
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.price} LE",
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 15 * SizeConfig.horizontalBlock),
                    Text("Duration:",
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.duration}",
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 15 * SizeConfig.horizontalBlock),
                    Text("Quantity:",
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.quantity}",
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Conditionally render post image
              if (validImageUrl != null)
                Container(
                  height: 201 * SizeConfig.verticalBlock,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5 * SizeConfig.textRatio),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    validImageUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Text("Image failed to load")),
                  ),
                ),
            ],
          ),

          Positioned(
            bottom: 0 * SizeConfig.verticalBlock,
            right: 10 * SizeConfig.horizontalBlock,
            child: Row(
              children: [
                offers(postId: post.id ?? ""),
                Text(
                  "${post.offersIds != null ? post.offersIds!.length : 0}",
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}