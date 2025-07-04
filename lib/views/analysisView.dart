import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class AnalysisView extends StatefulWidget {
  static String id = "AnalysisViewScreen";
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
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
          'Analysis',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16 * SizeConfig.verticalBlock,
              horizontal: 16 * SizeConfig.horizontalBlock),
          child: Column(
            children: [
              Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
