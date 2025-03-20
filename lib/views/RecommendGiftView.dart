import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/GiftRecommendationProducts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:provider/provider.dart';

import '../Providers/ProductProvider.dart';

class RecommendGift extends StatefulWidget {
  static String id = "RecommendGiftView";
  const RecommendGift({super.key});

  @override
  State<RecommendGift> createState() => _RecommendGiftState();
}

class _RecommendGiftState extends State<RecommendGift> {
  bool _start = false;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final Map<String, String> answers = {}; // To store questions and answers
  final TextEditingController _additionalInfoController = TextEditingController();

  // Define the questions and their answer options
  final Map<String, List<String>> questions = {
    "Who is the gift for?": ["Child", "Teen", "Young Adult", "Adult", "Senior"],
    "What is the occasion?": [
      "Birthday",
      "Anniversary",
      "Graduation",
      "Wedding",
      "Other"
    ],
    "What is your budget?": [
      "Under LE 50",
      "LE 50 - 100",
      "LE 100 - 200",
      "LE 200 - 500",
      "LE 500 +"
    ],
    "What are their interests?": [
      "Sports",
      "Tech",
      "Fashion",
      "Food",
      "Other"
    ],
    "Is there anything else we should know?": [], // Final question with a text field
  };

  @override
  void dispose() {
    _additionalInfoController.dispose();
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
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
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
          'Gift Picker',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20 * SizeConfig.verticalBlock),
        child: !_start
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Answer a few questions, and we’ll suggest the best gifts for your loved ones.",
              style: TextStyle(
                fontSize: 32 * SizeConfig.textRatio,
                color: Colors.black,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            customizeButton(
              buttonName: "Find the Perfect Gift!",
              buttonColor: SizeConfig.iconColor,
              fontColor: Colors.white,
              sufixIcon: Icons.wallet_giftcard_rounded,
              textSize: 24 * SizeConfig.textRatio,
              width: 309 * SizeConfig.horizontalBlock,
              height: 55 * SizeConfig.verticalBlock,
              onClickButton: () {
                setState(() {
                  _start = true;
                });
              },
            ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            Image.asset(
              'assets/images/3009227 1.png',
              width: SizeConfig.verticalBlock * 361,
              height: SizeConfig.verticalBlock * 361,
            ),
          ],
        )
            : Column(
          children: [
            // Display the current question
            Text(
              questions.keys.toList()[_currentQuestionIndex],
              style: TextStyle(
                fontSize: 32 * SizeConfig.textRatio,
                color: Colors.black,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10 * SizeConfig.verticalBlock),
            if (_currentQuestionIndex < questions.length - 1)
              Text(
                "Choose one option",
                style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  color: Colors.black,
                  fontFamily: "Roboto",
                ),
              ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            if (_currentQuestionIndex < questions.length - 1)
              ...questions.values
                  .toList()[_currentQuestionIndex]
                  .map((answer) {
                return Container(
                  width: 280 * SizeConfig.horizontalBlock,
                  height: 55 * SizeConfig.verticalBlock,
                  margin: EdgeInsets.symmetric(
                      vertical: 5 * SizeConfig.verticalBlock),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF5095B0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: RadioListTile<String>(
                    title: Text(
                      answer,
                      style: TextStyle(
                        fontSize: 24 * SizeConfig.textRatio,
                        color: SizeConfig.iconColor,
                      ),
                    ),
                    value: answer,
                    groupValue: _selectedAnswer ??
                        answers[questions.keys.toList()[_currentQuestionIndex]],
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value;
                        answers[questions.keys.toList()[_currentQuestionIndex]] = value!;
                      });
                    },
                    activeColor: Color(0xFF5095B0),
                  ),
                );
              }).toList(),
            if (_currentQuestionIndex == questions.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.horizontalBlock),
                child: MyTextFormField(
                  controller: _additionalInfoController,
                  width: 363 * SizeConfig.horizontalBlock,
                  height: 55 * SizeConfig.verticalBlock,
                  hintName: "Tell us more about what you’re looking for",
                  icon: Icons.edit_sharp,
                  maxLines: 3,
                ),
              ),
            Spacer(), // Pushes the buttons to the bottom
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  customizeButton(
                    buttonName: "Back",
                    buttonColor: Color(0xFFE9E9E9),
                    fontColor: SizeConfig.iconColor,
                    buttonIcon: Icons.arrow_back,
                    IconColor: SizeConfig.iconColor,
                    textSize: 18 * SizeConfig.textRatio,
                    width: 120 * SizeConfig.horizontalBlock,
                    height: 40 * SizeConfig.verticalBlock,
                    rad: 30,
                    onClickButton: () {
                      setState(() {
                        _currentQuestionIndex--;
                        _selectedAnswer = answers[questions.keys.toList()[_currentQuestionIndex]];
                      });
                    },
                  ),
                if (_currentQuestionIndex <= 0) Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    questions.length,
                        (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentQuestionIndex
                            ? Color(0xFFB36995)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (_currentQuestionIndex < questions.length - 1)
                  customizeButton(
                    buttonName: "Next",
                    buttonColor: SizeConfig.iconColor,
                    fontColor: Colors.white,
                    sufixIcon: Icons.arrow_forward,
                    textSize: 18 * SizeConfig.textRatio,
                    width: 120 * SizeConfig.horizontalBlock,
                    height: 40 * SizeConfig.verticalBlock,
                    rad: 30,
                    onClickButton: () {
                      if (_selectedAnswer != null ||
                          _currentQuestionIndex == questions.length - 1) {
                        setState(() {
                          _currentQuestionIndex++;
                          _selectedAnswer = null;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please select an answer."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                if (_currentQuestionIndex == questions.length - 1)
                  customizeButton(
                    buttonName: "Finish",
                    buttonColor: SizeConfig.iconColor,
                    fontColor: Colors.white,
                    sufixIcon: Icons.arrow_forward,
                    textSize: 18 * SizeConfig.textRatio,
                    width: 120 * SizeConfig.horizontalBlock,
                    height: 40 * SizeConfig.verticalBlock,
                    rad: 30,
                    onClickButton: () async {
                      if (_additionalInfoController.text.isNotEmpty || _selectedAnswer != null) {
                        // Save the final answer
                        answers[questions.keys.toList()[_currentQuestionIndex]] =
                            _additionalInfoController.text;

                        // Fetch gift recommendations
                        final prodProvider = Provider.of<productProvider>(context, listen: false);
                        await prodProvider.fetchGiftRecommendProducts(answers);

                        // Navigate to a new screen to display the recommendations
                        Navigator.pushNamed(context, GiftRecommendationProducts.id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please provide additional information."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}