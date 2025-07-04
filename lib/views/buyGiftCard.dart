import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import 'PaymentScreen.dart';

class giftCard extends StatefulWidget {
  static String id = "GiftCardScreen";
  const giftCard({super.key});

  @override
  State<giftCard> createState() => _giftCardState();
}

class _giftCardState extends State<giftCard> {
  final TextEditingController email = TextEditingController();
  final TextEditingController message = TextEditingController();
  final List<double> amounts = [25, 50, 100];
  double? selectedAmount;
  final TextEditingController customAmountController = TextEditingController();

  @override
  void dispose() {
    customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Gift Card',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * SizeConfig.horizontalBlock,
            vertical: 16 * SizeConfig.verticalBlock,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15 * SizeConfig.verticalBlock,
            children: [
              Text(
                "Amount",
                style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...amounts.map((amount) {
                    final isSelected = selectedAmount == amount;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount;
                          customAmountController.clear(); // Clear custom input
                        });
                      },
                      child: Container(
                        width: 100 * SizeConfig.horizontalBlock,
                        padding: EdgeInsets.symmetric(
                          vertical: 12 * SizeConfig.verticalBlock,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF5095B0)
                              : Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF223F4A)
                                : SizeConfig.iconColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          "LE $amount",
                          style: TextStyle(
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 100 * SizeConfig.horizontalBlock,
                    decoration: BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedAmount == null &&
                                customAmountController.text.isNotEmpty
                            ? Color(0xFF223F4A)
                            : SizeConfig.iconColor,
                        width: selectedAmount == null &&
                                customAmountController.text.isNotEmpty
                            ? 2
                            : 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * SizeConfig.horizontalBlock,
                      vertical: 10 * SizeConfig.verticalBlock,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          "LE",
                          style: TextStyle(
                            fontSize: 14 * SizeConfig.textRatio,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: customAmountController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onTap: () {
                              setState(() {
                                selectedAmount = null;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedAmount = null;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Other',
                              hintStyle: TextStyle(
                                fontSize: 16 * SizeConfig.textRatio,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontSize: 16 * SizeConfig.textRatio,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MyTextFormField(
                controller: email,
                labelText: "To",
                hintName: "Enter an email",
                hintStyle: TextStyle(
                  fontSize: 16 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                  color: Colors.grey,
                ),
                labelStyle: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
                width: 361 * SizeConfig.horizontalBlock,
                maxLines: 1,
                fillColor: Color(0xFFE0E0E0),
              ),
              MyTextFormField(
                controller: message,
                labelText: "Your message",
                hintName: "Enter a happy message",
                hintStyle: TextStyle(
                  fontSize: 16 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                  color: Colors.grey,
                ),
                labelStyle: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
                width: 361 * SizeConfig.horizontalBlock,
                maxLines: 1,
                fillColor: Color(0xFFE0E0E0),
              ),
              SizedBox(
                height: 40 * SizeConfig.verticalBlock,
              ),
              Center(
                child: customizeButton(
                    buttonName: 'Buy',
                    buttonColor: const Color(0xFF5095B0),
                    fontColor: const Color(0xFFF5F5F5),
                    width: 200 * SizeConfig.horizontalBlock,
                    height: 50 * SizeConfig.verticalBlock,
                    onClickButton: () {
                      final customAmount =
                          double.tryParse(customAmountController.text);

                      if (selectedAmount == null &&
                          (customAmount == null || customAmount <= 0)) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Missing Amount"),
                            content: Text(
                                "Please select or enter a valid gift card amount."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (email.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Missing Email"),
                            content: Text("Please enter a recipient email."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (message.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Missing Message"),
                            content: Text("Please enter a message."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      final amountToSend = selectedAmount ?? customAmount;

                      Navigator.pushNamed(
                        context,
                        Paymentscreen.id,
                        arguments: {
                          'type': 'GiftCard',
                          'price': amountToSend,
                          'mail': email.text.trim(),
                          'message': message.text.trim(),
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
