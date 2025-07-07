import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/SearchView.dart';
import 'Dimensions.dart';
import 'customizeTextFormField.dart';

Widget SearchRow(BuildContext context) {
  TextEditingController search = TextEditingController();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16 * SizeConfig.horizontalBlock),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, searchView.id),
            child: Container(
              child: MyTextFormField(
                onClickFunction: (context) async {
                  await Navigator.pushNamed(context, searchView.id);
                },
                controller: search,
                hintName: "Search",
                icon: Icons.search,
              ),
            ),
          ),
        ),

      ],
    ),
  );
}
