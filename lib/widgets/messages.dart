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
        child: Container(
          padding: EdgeInsets.all(10 * SizeConfig.horizontalBlock),
          width: 500 * SizeConfig.horizontalBlock,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Center section to show the dialog icon
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
              // Title section
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0 * SizeConfig.horizontalBlock),
                      child: Text(
                        title ?? "",
                        style: TextStyle(
                          fontSize: 22 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if(dialogIcon == null)
                    SizedBox(width:100 *SizeConfig.horizontalBlock ,),
                    Container(
                      width: 30 * SizeConfig.horizontalBlock,
                      height: 30 * SizeConfig.horizontalBlock,
                      decoration: BoxDecoration(
                        color: SizeConfig.iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16 * SizeConfig.verticalBlock),
              // Description section
              SingleChildScrollView(
                child: Center(
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
              // Actions (if provided)
              if (actions != null) ...[
                Divider(height: 1),
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
      );
    },
  );
}
