import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/Providers/offerProvider.dart';
import 'package:gp_frontend/views/addPost.dart';
import 'package:gp_frontend/widgets/customPost.dart';
import 'package:provider/provider.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../Providers/postProvider.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/Dimensions.dart';

class posts extends StatefulWidget {
  static String id = "posts";
  posts({super.key});

  @override
  State<posts> createState() => _postsState();
}

class _postsState extends State<posts> {
  postProvider myPostProvider = postProvider();
  List<postModel> posts = [];
  Future<void>? _postsFuture;
  late int page;
  late String role;




  @override
  void initState() {
    super.initState();
    page = 0;
  }



  Future<void> getPosts(int page) async {
    if (page == 0) {
      await myPostProvider.getClientPosts();
    } else {
      await myPostProvider.getAllPosts();
    }
    setState(() {
      posts = myPostProvider.posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get page argument once here:
    final routePage = ModalRoute.of(context)?.settings.arguments as int?;
    if (routePage != null && routePage != page) {
      page = routePage;
      _postsFuture = getPosts(page);
    }
    _postsFuture = _postsFuture ?? getPosts(page);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 85 * SizeConfig.verticalBlock,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF223F4A),
                    Color(0xFF5095B0),
                  ],
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
              page == 0 ? 'My Posts' : 'Posts',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 20 * SizeConfig.textRatio,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  loadProfileByRole(
                    context: context,
                    onCustomerLoaded: (customer) {
                      print("Customer loaded: ${customer.name}");
                    },
                    onCrafterLoaded: (crafter) {
                      print("Crafter loaded: ${crafter.name}");
                    },
                  );
                  },
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          body: Consumer<offerProvider>(

            builder: (context , offProv , child) {
              return FutureBuilder(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.rubik(
                          fontSize: 20 * SizeConfig.textRatio,
                          color: Color(0x503C3C3C),
                        ),
                      ),
                    );
                  } else if (posts.isEmpty) {
                    return Stack(
                      children: [
                        Center(
                          child: Text(
                            "You have not posted anything yet.",
                            style: GoogleFonts.rubik(
                              fontSize: 20 * SizeConfig.textRatio,
                              color: Color(0x503C3C3C),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15 * SizeConfig.verticalBlock,
                          right: 15 * SizeConfig.horizontalBlock,
                          child: Container(
                            width: 50 * SizeConfig.horizontalBlock,
                            height: 50 * SizeConfig.verticalBlock,
                            decoration: BoxDecoration(
                              color: SizeConfig.iconColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25 * SizeConfig.textRatio),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, addPost.id ,arguments: {'type': 'add'});
                              },
                              icon: Icon(Icons.add),
                              iconSize: 30 * SizeConfig.textRatio,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:index != posts.length-1?
                              EdgeInsets.only(left: 10.0 * SizeConfig.horizontalBlock,
                              right: 10.0 * SizeConfig.horizontalBlock,
                             ):
                              EdgeInsets.only(
                              left:10.0 * SizeConfig.horizontalBlock,
                              right: 10.0 * SizeConfig.horizontalBlock,
                              bottom: 50.0 * SizeConfig.horizontalBlock),
                              child: customPost(posts[index],isOrder: false,),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 15 * SizeConfig.verticalBlock,
                          right: 15 * SizeConfig.horizontalBlock,
                          child: Container(
                            width: 50 * SizeConfig.horizontalBlock,
                            height: 50 * SizeConfig.verticalBlock,
                            decoration: BoxDecoration(
                              color: SizeConfig.iconColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25 * SizeConfig.textRatio),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(context, addPost.id , arguments: {'type':'add'});
                                if (result == true) {
                                  setState(() {
                                    _postsFuture = getPosts(page);
                                  });
                                }
                              },
                              icon: Icon(Icons.add),
                              iconSize: 30 * SizeConfig.textRatio,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          ),
        );

  }
}
