import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

Future<void> showCustomPopup(
    BuildContext context,
    String? title,
    String description,
    List<Widget>? actions, {
      Icon? dialogIcon,
    }) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0 * SizeConfig.textRatio),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10 * SizeConfig.horizontalBlock),
              width: 500 * SizeConfig.horizontalBlock,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (dialogIcon != null)
                    Center(
                      child: Container(
                        height: 80 * SizeConfig.verticalBlock,
                        width: 80 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SizeConfig.iconColor,
                        ),
                        child: dialogIcon,
                      ),
                    ),

                  SizedBox(height: 16 * SizeConfig.verticalBlock),

                  // Title row with flexible text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title ?? "",
                          style: TextStyle(
                            fontSize: 22 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      if (dialogIcon == null)
                        IconButton(
                          icon: Icon(Icons.clear, color: SizeConfig.iconColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                    ],
                  ),

                  SizedBox(height: 16 * SizeConfig.verticalBlock),

                  // Description
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 16 * SizeConfig.textRatio,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),

                  SizedBox(height: 20 * SizeConfig.verticalBlock),

                  if (actions != null && actions.isNotEmpty) ...[
                    SizedBox(height: 16 * SizeConfig.verticalBlock),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions
                          .map((action) => Padding(
                        padding: EdgeInsets.only(
                            left: 8 * SizeConfig.horizontalBlock),
                        child: action,
                      ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
