import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/views/addPost.dart';
import 'package:gp_frontend/widgets/customPost.dart';

import '../Providers/postProvider.dart';
import '../widgets/Dimensions.dart';
import 'ProfileView.dart';

class posts extends StatefulWidget {
  static String id = "posts";
  const posts({super.key});

  @override
  State<posts> createState() => _postsState();
}

class _postsState extends State<posts> {
  postProvider myPostProvider = postProvider();
  List<postModel> posts = [];
  getPosts() async {
    await myPostProvider.getPosts();
    posts = myPostProvider.posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight:
            85 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Rounded bottom-left corner
              bottomRight: Radius.circular(20), // Rounded bottom-right corner
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
          'My Posts',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Profile.id);
              },
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
              ))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              posts.isEmpty) {
            print(snapshot.hasData);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "You have not posted anything yet.",
                  style: GoogleFonts.rubik(
                      fontSize: 20 * SizeConfig.textRatio,
                      color: Color(0x503C3C3C)),
                )),
              ],
            );
          } else {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
                        child: customPost(posts[index]),
                      );
                    }),
                Positioned(
                    bottom: 15 * SizeConfig.verticalBlock,
                    right: 15 * SizeConfig.horizontalBlock,
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: SizeConfig.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(25 * SizeConfig.textRatio))
                      ),
                      child: IconButton(onPressed: (){Navigator.pushNamed(context, addPost.id);}, icon:Icon( Icons.add) ,
                        iconSize: 30 * SizeConfig.textRatio,color: Colors.white,),
                    )
                )
              ],
            );
          }
        },
      ),
    );
  }
}
