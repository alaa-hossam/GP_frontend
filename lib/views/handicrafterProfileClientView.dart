import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/handcrafterModel.dart';
import 'package:gp_frontend/ViewModels/handcrafterViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeButton.dart';
import 'ReelsView.dart';

class HandcrafterProfileClientView extends StatefulWidget {
  static String id = "HandcrafterProfileClientViewScreen";
  final String handCrafterId ;
  const HandcrafterProfileClientView({required this.handCrafterId});

  @override
  State<HandcrafterProfileClientView> createState() => _HandcrafterProfileClientViewState();
}

class _HandcrafterProfileClientViewState extends State<HandcrafterProfileClientView> {
  handcrafterViewModel hvm = handcrafterViewModel();
  handcrafterModel? _handcrafter;
  bool _isLoading = true;
  late productProvider prodProvider;

  double _calculateButtonWidth(String text, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14 * SizeConfig.textRatio,
          fontFamily: "Roboto",
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width + 40 * SizeConfig.horizontalBlock;
  }

  Future<void> _loadHandcrafterData() async {
    try {
      final handcrafter = await hvm.fetchHandcrafterById(widget.handCrafterId);
      setState(() {
        _handcrafter = handcrafter;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading customer data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile data')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHandcrafterData();
    prodProvider = Provider.of<productProvider>(context, listen: false);
    prodProvider.handCrafterProducts.clear();
    prodProvider.fetchHandCrafterById(widget.handCrafterId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 315 * SizeConfig.verticalBlock,
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
        leading: null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10 * SizeConfig.verticalBlock,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: SizeConfig.textRatio * 15,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            // Profile content below
            Center(
              child: CircleAvatar(
                backgroundColor: SizeConfig.iconColor,
                radius: SizeConfig.horizontalBlock * 70,
                child: CircleAvatar(
                  radius: SizeConfig.horizontalBlock * 67,
                  backgroundColor: Colors.white,
                  child: _handcrafter?.profileURL != null
                      ? ClipOval(
                    child: Image.network(
                      _handcrafter!.profileURL!,
                      width: SizeConfig.horizontalBlock * 134,
                      height: SizeConfig.horizontalBlock * 134,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Center(
                    child: Icon(
                      Icons.person,
                      size: SizeConfig.horizontalBlock * 60,
                      color: SizeConfig.iconColor,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                _handcrafter?.name ?? 'No Name',
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 24 * SizeConfig.textRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              _handcrafter?.description ?? 'NO Description',
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16 * SizeConfig.textRatio,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _handcrafter!.rate!.toStringAsFixed(1), // Display rate with 1 decimal place
                  style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 10 * SizeConfig.horizontalBlock),
                ...List.generate(5, (index) {
                  if (index < _handcrafter!.rate!) {
                    return Icon(
                      Icons.star,
                      color: Color(0xFFD4931C), // Gold color for filled stars
                      size: 30 * SizeConfig.textRatio,
                    );
                  } else {
                    return Icon(
                      Icons.star_border,
                      color: Color(0xFFD4931C), // Gold color for outlined stars
                      size: 30 * SizeConfig.textRatio,
                    );
                  }
                }),
              ],
            ),

          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 15 * SizeConfig.verticalBlock,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15 * SizeConfig.verticalBlock),
              child: SizedBox(
                height: 50 * SizeConfig.verticalBlock,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Products",
                      buttonColor: Color(0xFF5095B0),
                      fontColor: Color(0xFFFFFFFF),
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Products", context),
                      height: 40 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Reels",
                      buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                      fontColor: SizeConfig.iconColor,
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Reels", context),
                      height: 40 * SizeConfig.verticalBlock,
                      onClickButton: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReelsView(handcrafter: _handcrafter!)
                          ),);
                      },
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Orders",
                      buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                      fontColor: SizeConfig.iconColor,
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Orders", context),
                      height: 40 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  ],
                ),
              ),
            ),
            Consumer<productProvider>(
              builder: (context, prodProvider, child) {
                if (prodProvider.handCrafterProducts.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two products per row
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      childAspectRatio: 0.7, // Adjust based on your design
                    ),
                    itemCount: prodProvider.handCrafterProducts.length,
                    itemBuilder: (context, index) {
                      var product = prodProvider.handCrafterProducts[index];
                      return customProduct(
                        product.imageURL,
                        product.name,
                        Category: product.category,
                        product.price,
                        product.rate,
                        product.id,
                        false,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
