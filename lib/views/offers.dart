import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gp_frontend/Providers/offerProvider.dart';
import 'package:gp_frontend/views/addOffer.dart';
import 'package:gp_frontend/widgets/customOffer.dart';
import 'package:provider/provider.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/Dimensions.dart';

class offers extends StatefulWidget {
  String postId;
  String clientId;
  offers({super.key , required this.postId , required this.clientId});

  @override
  State<offers> createState() => _offersState();
}

class _offersState extends State<offers> {
  offerProvider offerProv = offerProvider();
  final token = Token();
  bool handcrafter = false ;



  checkRole()async{
    final roleSQL = await token.getRole();
    if (roleSQL == 'Handicrafter') {
      handcrafter = true;
    } else if (roleSQL == 'Client') {
      handcrafter = false;

    }
    return true;
  }



  Future<List<dynamic>> _fetchOffers() async {
    await offerProv.getOffers(widget.postId);
    return offerProv.offers;
  }


  void _openOffersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          children: [
            Container(
              height: 541 * SizeConfig.verticalBlock,
              width: 361 * SizeConfig.horizontalBlock,
              padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
              child: Column(
                children: [
                  Container(
                    width: 56 * SizeConfig.horizontalBlock,
                    height: 1 * SizeConfig.verticalBlock,
                    color: SizeConfig.iconColor,
                  ),
                  SizedBox(height: 16 * SizeConfig.verticalBlock),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _fetchOffers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error fetching offers"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No offers found"));
                        }

                        final offers = snapshot.data!;

                        return Consumer<offerProvider>(
                          builder: (context, offProv, child) {
                            return ListView.builder(
                              itemCount: offers.length,
                              itemBuilder: (context, index) {
                                return customOffer(offer: offers[index] , clientId: widget.clientId ?? "");
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16 * SizeConfig.verticalBlock),

                ],
              ),
            ),
            Positioned(
              bottom: 15 * SizeConfig.verticalBlock,
              right: 15 * SizeConfig.horizontalBlock,
              child: FutureBuilder(
                  future: checkRole(),
                  builder: (context,child) {
                    if(handcrafter){
                      return Container(
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
                            Navigator.pushNamed(context, addOffer.id,arguments: widget.postId);},

                          icon: Icon(Icons.add),
                          iconSize: 30 * SizeConfig.textRatio,
                          color: Colors.white,
                        ),
                      );

                    }
                    return Container();
                  }
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: (){_openOffersBottomSheet(context);}, icon:  FaIcon(
          FontAwesomeIcons.solidComment,
          color: SizeConfig.secondColor,
          size: 28,
        ),),
        IconButton(onPressed: (){_openOffersBottomSheet(context);}, icon:  FaIcon(
          FontAwesomeIcons.solidComment,
          color: Colors.white,
          size: 26,
        ),),


      ],
    );
  }
}