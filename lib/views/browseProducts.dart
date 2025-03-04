import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../ViewModels/CategoryViewModel.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';
import 'ProfileView.dart';

class browseProducts extends StatefulWidget {
  static String id = "browseProductsScreen";

  const browseProducts({super.key});
  @override
  State<browseProducts> createState() => _BrowseProductsState();
}

class _BrowseProductsState extends State<browseProducts> {
  TextEditingController search = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none, size:24 * SizeConfig.textRatio,),
              ),
              Icon(
                Icons.shopping_cart_outlined,
                size:24 * SizeConfig.textRatio,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Profile.id);
                },
                icon: Icon(Icons.account_circle_outlined, size:24 * SizeConfig.textRatio,),
              ),
            ],
          )
        ],
        title: Row(
          children: [
            Image(
              image: AssetImage("assets/images/Frame 36920.png"),
              width: SizeConfig.textRatio * 40,
              height: SizeConfig.textRatio * 40,
              fit: BoxFit.cover,
            ),
            Text(
              "SAN3A",
              style: TextStyle(
                color: Color(0xFF073477),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
                fontSize: SizeConfig.textRatio * 24,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: SizeConfig.horizontalBlock * 5,
            children: [
              MyTextFormField(
                controller: search,
                hintName: "Search",
                icon: Icons.search,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: SizeConfig.iconColor,
                    size: 24 * SizeConfig.textRatio,
                  ),
                  onPressed: () {},
                ),
                width: 253 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
              ),
              Container(
                width:48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0x80E9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Icon(Icons.tune , size: 24 * SizeConfig.textRatio,),
              ),
              Container(
                width:48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0x80E9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Icon(Icons.compare_outlined , size: 24 * SizeConfig.textRatio,),
              ),
            ],
          ),
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.categories.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 43 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      var category = categoryProvider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Row(
                          children: [
                            Customizecategory("${category}", isSelected),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0),
    );
  }
}




