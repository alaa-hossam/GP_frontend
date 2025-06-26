import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/CategoryProvider.dart';
import '../ViewModels/CategoryViewModel.dart';
import 'Dimensions.dart';
import 'customizeButton.dart';

class categories extends StatefulWidget {
  const categories({super.key});

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  CategoryViewModel CVM = CategoryViewModel();

  Future<List<dynamic>> _fetchCategories() async {
    await CVM.fetchAllCatefories();
    return CVM.allCategories;
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).clearSelectedCategory();
    });
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
                "Categories",
                style: TextStyle(
                  fontSize: 24 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24 * SizeConfig.verticalBlock),

              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching Categories"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No Categories found"));
                    }

                    final categories = snapshot.data!;

                    return Consumer<CategoryProvider>(
                      builder: (context, catProvider, child) {
                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return RadioListTile<String>(
                              title: Text(category.name),
                              value: category.id,
                              groupValue: catProvider.selectedCategoryId,
                              onChanged: (String? value) {
                                if (value != null) {
                                  catProvider.selectCategory(category.name, category.id);
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
          if (catProvider.selectedCategory != null)
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8 * SizeConfig.horizontalBlock),
                    child: customizeButton(
                      buttonName: catProvider.selectedCategory!,
                      buttonColor: Color(0xFF5095B0),
                      fontColor: Color(0xFFFFFFFF),
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth(catProvider.selectedCategory!, context),
                      height: 25 * SizeConfig.verticalBlock,
                    ),
                  ),
                ],
              ),
            ),

          customizeButton(
            buttonColor: Color(0xFFB36995), // dark blue for Update
            buttonName: catProvider.selectedCategory == null ? "Add" : "Update",
            fontColor: Colors.white,
            buttonIcon: catProvider.selectedCategory == null ? Icons.add : Icons.edit,
            IconColor: Colors.white,
            textSize: 14 * SizeConfig.textRatio,
            width: 80 * SizeConfig.horizontalBlock,
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
