import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class variationScreen extends StatefulWidget {
  List<dynamic>? variations , finalProducts;

  variationScreen(this.variations, this.finalProducts){
    print(variations);
  }

  @override
  State<variationScreen> createState() => _variationScreenState();
}

class _variationScreenState extends State<variationScreen> {

  List<String> _getUniqueVariationTypes() {
    final uniqueTypes = <String>[];
    print("variations are");
    print(widget.variations);
    if(widget.variations != null){
      for (final variation in widget.variations!) {
        if (!uniqueTypes.contains(variation['variationType'])) {
          uniqueTypes.add(variation['variationType']);
        }
      }
    }
    return uniqueTypes;


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Container(
            width: 361 * SizeConfig.horizontalBlock,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.textRatio)),
              color: Color(0X50E9E9E9),
              border: Border.all(color: SizeConfig.iconColor),
            ),
            child: Padding(
              padding:  EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
              child: Column(
                  children: [
                    SizedBox(
                      height: 100 * SizeConfig.verticalBlock,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        itemCount: _getUniqueVariationTypes().length,
                          itemBuilder: (context , index){
                          return Text("dd");
                          }),
                    )
                  ],

              ),
            ),
          )
      ],
    );
  }
}
