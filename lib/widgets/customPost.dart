import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class customPost extends StatelessWidget {
  final postModel post;

  customPost(this.post);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 385 * SizeConfig.horizontalBlock,
          // No fixed height — height will grow with content
          decoration: BoxDecoration(
            color: Color(0x50E9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: SizeConfig.iconColor),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.0), // Optional spacing between posts
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Padding(
                          //   padding:
                          //   EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                          //   child:
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(post.clientImage!),
                            //   backgroundColor: Colors.transparent,
                            //   radius: 20 * SizeConfig.horizontalBlock,
                            // ),
                          // ),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock),
                          Text(
                            "${post.userName}",
                            style: GoogleFonts.roboto(
                                fontSize: 10 * SizeConfig.textRatio),
                          )
                        ],
                      ),
                      PopupMenuButton<int>(
                        onSelected: (value) {
                          // Handle item selection
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text("Option 1"),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text("Option 2"),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text("Option 3"),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10 * SizeConfig.horizontalBlock),
                    child: Text(
                      "${post.description}",
                      style: GoogleFonts.roboto(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 40.0 * SizeConfig.horizontalBlock,
                        top: 10 * SizeConfig.verticalBlock),
                    child: Row(
                      children: [
                        Text("Price:",
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0x503C3C3C))),
                        SizedBox(width: 5 * SizeConfig.horizontalBlock),
                        Text("${post.price} LE",
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(width: 15 * SizeConfig.horizontalBlock),
                        Text("Duration:",
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0x503C3C3C))),
                        SizedBox(width: 5 * SizeConfig.horizontalBlock),
                        Text("${post.duration}",
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(width: 15 * SizeConfig.horizontalBlock),
                        Text("Quantity:",
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0x503C3C3C))),
                        SizedBox(width: 5 * SizeConfig.horizontalBlock),
                        Text("${post.quantity}",
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Text("${post.title}"),
                  SizedBox(
                    height: 10 * SizeConfig.verticalBlock,
                  ),
                  Container(
                    height: 201 * SizeConfig.verticalBlock,
                    width: double.infinity,
                    child: Image.network(
                      post.postImage ?? "assets/images/Frame 36920.png" ,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 2 * SizeConfig.verticalBlock,
                right: 2 * SizeConfig.horizontalBlock,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment,
                    color: SizeConfig.iconColor,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}