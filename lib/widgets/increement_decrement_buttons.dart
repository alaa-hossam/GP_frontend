import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Providers/postProvider.dart';
import 'Dimensions.dart';
import 'customizeTextFormField.dart';

class incrementDecrementButtons extends StatefulWidget {
  String Title , hint;
  String? descripton;
  TextEditingController controller;

  incrementDecrementButtons(this.Title, this.hint,this.controller , this.descripton);

  @override
  State<incrementDecrementButtons> createState() => _incrementDecrementButtonsState(Title , hint, controller, descripton);
}

class _incrementDecrementButtonsState extends State<incrementDecrementButtons> {
  String Title, hint;
  String? description;
  TextEditingController controller;



  _incrementDecrementButtonsState(this.Title, this.hint , this.controller , this.description);

  @override
  Widget build(BuildContext context) {
    final addPostProvider = Provider.of<postProvider>(context);

    return Padding(
      padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${Title}" , style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.verticalBlock),),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 40 * SizeConfig.horizontalBlock,
                      height: 40 * SizeConfig.verticalBlock,
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                        borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                      ),

                    ),
                    Positioned(
                      left: -4 * SizeConfig.horizontalBlock,
                      top: -11 * SizeConfig.verticalBlock,
                      child:IconButton(
                        onPressed: () => addPostProvider.decrement(controller),
                        icon: Icon(Icons.minimize_outlined),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
                  child: MyTextFormField(
                    type: TextInputType.number,
                    width: 150 * SizeConfig.horizontalBlock,
                    hintName: "${hint}",
                    hintStyle: TextStyle(color: Color(0x503C3C3C) , fontSize: 20),
                    maxLines: 3,
                    controller: controller,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 40 * SizeConfig.horizontalBlock,
                      height: 40 * SizeConfig.verticalBlock,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                        borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                      ),

                    ),
                    Positioned(
                      left: -4 * SizeConfig.horizontalBlock,
                      top: -4 * SizeConfig.verticalBlock,
                      child:IconButton(
                        onPressed: () => addPostProvider.increment(controller),
                        icon: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 300 * SizeConfig.horizontalBlock,
              child: Center(
                child: Text(description?? "" ,
                  textAlign: TextAlign.center, // <-- Add this line
                  style: GoogleFonts.roboto(fontSize: 14 * SizeConfig.textRatio , color: Color(0x503C3C3C)),),
              ),
            ),
          ),
          SizedBox(
            height: 10 * SizeConfig.verticalBlock,
          )
        ],
      ),
    );
  }
}
