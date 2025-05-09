import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/messages.dart';

class voucherContainer extends StatelessWidget {
  final String code , type;
  final int amount;

  voucherContainer({required this.code,required this.amount,required this.type});

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    showCustomPopup(context, "Copy", "Copied to clipboard!" , [],);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150 * SizeConfig.verticalBlock,
      width: 354 * SizeConfig.horizontalBlock,
      decoration: BoxDecoration(
        color: Color(0x50E9E9E9),
        borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
        border: Border.all(color: SizeConfig.iconColor),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10 * SizeConfig.verticalBlock),
          child: Column(
            children: [
              Text(
                code,
                style: GoogleFonts.roboto(fontSize: 32),
              ),
              SizedBox(height: 5 * SizeConfig.verticalBlock),
              Text(
                type.toLowerCase() == "amount" ? "Get ${amount} EG OFF" :
                "Get ${amount}% OFF",
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              SizedBox(height: 5 * SizeConfig.verticalBlock),
              customizeButton(
                buttonName: "COPY CODE",
                buttonColor: SizeConfig.iconColor,
                fontColor: Colors.white,
                height: 50 * SizeConfig.verticalBlock,
                width: 160 * SizeConfig.horizontalBlock,
                onClickButton: () => _copyToClipboard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}