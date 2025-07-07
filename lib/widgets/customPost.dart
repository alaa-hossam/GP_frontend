import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/CommomnFunctions/validImage.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/views/addPost.dart';
import 'package:gp_frontend/views/offers.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import '../Providers/postProvider.dart';
import '../SqfliteCodes/Token.dart';

class customPost extends StatefulWidget {
  final postModel post;
  final bool? isOrder;
  const customPost(this.post, {Key? key,this.isOrder}) : super(key: key);

  @override
  State<customPost> createState() => _CustomPostState();
}

class _CustomPostState extends State<customPost> {
  bool match = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkId();
  }

  Future<void> checkId() async {
    Token token = Token();
    final idSQL = await token.getUUID();
    setState(() {
      match = (idSQL == widget.post.clientId);
      loading = false;
    });
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    final difference = now.difference(createdAt);

    if (difference.inHours > 8640) {
      return "${(difference.inHours / 8760).toInt()} yrs";
    } else if (difference.inHours > 720) {
      return "${(difference.inHours / 720).toInt()} mos";
    } else if (difference.inHours > 24) {
      return "${(difference.inHours / 24).toInt()} days";
    } else {
      return "${difference.inHours} hrs";
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    DateTime createdAt = DateTime.tryParse(post.createdAt ?? "") ?? DateTime.now();
    final timeAgo = _getTimeAgo(createdAt);
    final validImageUrl = ValidateImage().getValidImageUrl(post.postImage);
    final validProfileImageUrl = ValidateImage().getValidImageUrl(post.clientImage);

    return Container(
      width: 385 * SizeConfig.horizontalBlock,
      decoration: BoxDecoration(
        color: const Color(0x50E9E9E9),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: SizeConfig.iconColor),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0 * SizeConfig.verticalBlock),
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
                          Text("${post.userName}", style: GoogleFonts.roboto(fontSize: 10 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                          Text(timeAgo, style: GoogleFonts.roboto(fontSize: 8 * SizeConfig.textRatio, color: const Color(0x503C3C3C))),
                        ],
                      ),

                    ],
                  ),
                  if (!loading && match)
                    PopupMenuButton<int>(
                      onSelected: (value) async {
                        if (value == 1) {
                          Navigator.pushNamed(context, addPost.id , arguments: {'type':'update' , 'post': post });
                        } else if (value == 2) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Post"),
                              content: const Text("Are you sure you want to delete this post?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final myPostProvider = Provider.of<postProvider>(context, listen: false);
                            await myPostProvider.deletePost(widget.post.id!);
                            await myPostProvider.getAllPosts();

                          }
                        }
                      },

                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 1, child: Text("Update Post")),
                        PopupMenuItem(value: 2, child: Text("Delete Post")),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                ],
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.horizontalBlock),
                child: Text("${post.title}", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10 * SizeConfig.verticalBlock),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15 * SizeConfig.horizontalBlock),
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
                    Text("Price:", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.price} LE", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 15 * SizeConfig.horizontalBlock),
                    Text("Duration:", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.duration}", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 15 * SizeConfig.horizontalBlock),
                    Text("Quantity:", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0x503C3C3C))),
                    SizedBox(width: 5 * SizeConfig.horizontalBlock),
                    Text("${post.quantity}", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              if (validImageUrl != null)
                Container(
                  height: 201 * SizeConfig.verticalBlock,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5 * SizeConfig.textRatio)),
                  child: Image.network(
                    validImageUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => const Center(child: Text("Image failed to load")),
                  ),
                ),
              if(widget.isOrder!) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.horizontalBlock,vertical: 10 * SizeConfig.verticalBlock),
                  child: Container(
                    height: 97 * SizeConfig.verticalBlock,
                    width: 350 * SizeConfig.horizontalBlock,
                    padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.horizontalBlock,vertical: 10 * SizeConfig.verticalBlock),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5 * SizeConfig.textRatio),
                      color: Color(0xFFE9E9E9).withOpacity(0.5),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${post.aprovedOffer!.description!}", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15 * SizeConfig.verticalBlock),
                          Row(
                            children: [
                              Text("Price:", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0x503C3C3C))),
                              SizedBox(width: 5 * SizeConfig.horizontalBlock),
                              Text("${post.aprovedOffer!.price} LE", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 5 * SizeConfig.verticalBlock),
                          Row(
                            children: [
                              Text("Duration:", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0x503C3C3C))),
                              SizedBox(width: 5 * SizeConfig.horizontalBlock),
                              Text("${post.aprovedOffer!.duration}", style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if(widget.isOrder! == false)
            Positioned(
              bottom: 0,
              right: 10 * SizeConfig.horizontalBlock,
              child: Row(
                children: [
                  offers(postId: post.id ?? "", clientId: post.clientId ?? ""),
                  Text(
                    "${post.offersIds?.length ?? 0}",
                    style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
