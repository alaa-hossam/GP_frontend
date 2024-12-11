import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';

class Home extends StatefulWidget {
  static String id = "homeScreen";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  TextEditingController filter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20 * SizeConfig.verticalBlock),

              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  SizedBox(
                    width: 10 * SizeConfig.horizontalBlock,
                  ),
                  Icon(
                    Icons.account_circle_outlined,
                  ),
                ],
              ),
            )
          ],
          title: Text("Logo"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20 * SizeConfig.horizontalBlock,
                  right: 20 * SizeConfig.horizontalBlock),
              child: Row(
                children: [
                  MyTextFormField(
                    controller: search,
                    hintName: "Search",
                    icon: Icons.search,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner_outlined,
                        color: SizeConfig.iconColor,
                      ),
                      onPressed: () {},
                    ),
                    width: 300,
                    height: 45,
                  ),
                  SizedBox(width: 20 * SizeConfig.horizontalBlock),
                  MyTextFormField(
                    controller: filter,
                    icon: Icons.tune,
                    width: 48 - (20 * SizeConfig.horizontalBlock),
                    height: 45,
                  )
                ],
              ),
            ),
            SizedBox(height: 10* SizeConfig.verticalBlock,)

          ],
        ),
    );
  }
}
