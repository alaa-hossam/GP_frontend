import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class Customizecategory extends StatelessWidget {
  String title;
  bool Selected;
  Customizecategory(this.title , this.Selected);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Selected ?  SizeConfig.iconColor : Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.all(width: 2, color: SizeConfig.iconColor)
      ),

      child: Text("${title}" ,style: TextStyle(fontSize: 20),),
    );
  }
}
