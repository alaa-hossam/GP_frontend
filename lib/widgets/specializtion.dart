import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/CategoryProvider.dart';
import '../ViewModels/CategoryViewModel.dart';
import 'Dimensions.dart';
import 'customizeButton.dart';

class specializtions extends StatefulWidget {
  const specializtions({super.key});

  @override
  State<specializtions> createState() => _specializtionsState();
}

class _specializtionsState extends State<specializtions> {
  CategoryViewModel CVM = CategoryViewModel();

  Future<List<dynamic>> _fetchSpecializations() async {
    await CVM.fetchSpecialization();
    return CVM.specialization;
  }

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

  void _openSpecializationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
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

              Text(
                "Specializations",
                style: TextStyle(
                  fontSize: 24 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24 * SizeConfig.verticalBlock),

              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchSpecializations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching specializations"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No specializations found"));
                    }

                    final specializations = snapshot.data!;

                    return Consumer<CategoryProvider>(
                      builder: (context, catProvider, child) {
                        return ListView.builder(
                          itemCount: specializations.length,
                          itemBuilder: (context, index) {
                            final specialization = specializations[index];
                            return RadioListTile<String>(
                              title: Text(specialization.name),
                              value: specialization.id,
                              groupValue: catProvider.selectedSpecializationId,
                              onChanged: (String? value) {
                                if (value != null) {
                                  catProvider.selectSpecialization(specialization.name, specialization.id);
                                }
                              },
                              activeColor: SizeConfig.secondColor,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 16 * SizeConfig.verticalBlock),

              customizeButton(
                buttonName: 'Select',
                buttonColor: Color(0xFF5095B0),
                fontColor: const Color(0xFFF5F5F5),
                onClickButton: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<CategoryProvider>(context);

    return Container(
      padding: EdgeInsets.all(10 * SizeConfig.horizontalBlock),
      height: 60 * SizeConfig.verticalBlock,
      width: 361 * SizeConfig.horizontalBlock,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: SizeConfig.iconColor),
        color: const Color(0x80E9E9E9),
      ),
      child: Row(
        children: [
          if (catProvider.selectedSpecialization != null)
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8 * SizeConfig.horizontalBlock),
                    child: customizeButton(
                      buttonName: catProvider.selectedSpecialization!,
                      buttonColor: Color(0xFF5095B0),
                      fontColor: Color(0xFFFFFFFF),
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth(catProvider.selectedSpecialization!, context),
                      height: 25 * SizeConfig.verticalBlock,
                    ),
                  ),
                ],
              ),
            ),

          customizeButton(
            buttonColor: Color(0xFFB36995),
            buttonName: "Add",
            fontColor: Color(0xFFFFFFFF),
            buttonIcon: Icons.add,
            IconColor: Color(0xFFFFFFFF),
            textSize: 14 * SizeConfig.textRatio,
            width: 60 * SizeConfig.horizontalBlock,
            height: 25 * SizeConfig.verticalBlock,
            onClickButton: () {
              _openSpecializationsBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }
}
