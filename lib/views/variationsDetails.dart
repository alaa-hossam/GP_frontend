import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/detailsProvider.dart';
import 'package:provider/provider.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class variationScreen extends StatefulWidget {
  final List<dynamic>? variations , finalProducts;

  variationScreen(this.variations, this.finalProducts);

  @override
  State<variationScreen> createState() => _variationScreenState();
}

class _variationScreenState extends State<variationScreen> {
  final variationMap = <String, List<String>>{};

  Map<String, List<String>> _getVariationMap() {
    if (widget.variations != null) {
      for (final variation in widget.variations!) {
        final variationType = variation['variationType'];
        final variationValue = variation['variationValue'];

        if (variationMap.containsKey(variationType)) {
          variationMap[variationType]!.add(variationValue);
        } else {
          variationMap[variationType] = [variationValue];
        }
      }
    }
    return variationMap;
  }

  @override
  Widget build(BuildContext context) {
    _getVariationMap();
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
            padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: variationMap.keys.length,
                    itemBuilder: (context, index) {
                      var key = variationMap.keys.elementAt(index);
                      var values = variationMap[key];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$key",
                            style: GoogleFonts.roboto(
                              fontSize: 20 * SizeConfig.textRatio,
                              color: Color(0X80000000),
                            ),
                          ),
                          SizedBox(height: 10 * SizeConfig.verticalBlock),
                          SizedBox(
                            height: 50 * SizeConfig.verticalBlock,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: values?.length,
                              itemBuilder: (context, valueIndex) {
                                final value = values?[valueIndex];

                                return Consumer<detailsProvider>(
                                  builder: (context , detailsProvider , child){
                                    return GestureDetector(
                                      onTap: () {

                                        detailsProvider.selectVariation(key, value!);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: 8.0 * SizeConfig.horizontalBlock,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12 * SizeConfig.horizontalBlock,
                                          vertical: 6 * SizeConfig.verticalBlock,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10 * SizeConfig.textRatio),
                                          ),
                                          color: Color(0X50E9E9E9),
                                          border: Border.all(
                                            width: detailsProvider.selectedVariations[key] == value ? 4 : 1,
                                            color: SizeConfig.iconColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$value",
                                            style: GoogleFonts.rubik(
                                              fontSize: 20 * SizeConfig.textRatio,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}