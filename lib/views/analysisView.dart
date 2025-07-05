import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../Models/handcrafterModel.dart';
import '../ViewModels/handcrafterViewModel.dart';

class AnalysisView extends StatefulWidget {
  static String id = "AnalysisViewScreen";
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  handcrafterViewModel hvm = handcrafterViewModel();
  handcrafterAnalysisModel? _handcrafterAnalysis;
  String interval = "DAYS";
  bool _isLoading = true;
  List<String> _allPeriods = [];

  List<BarChartGroupData> _buildBarGroups() {
    final visits = _handcrafterAnalysis?.visits ?? [];
    final customMade = _handcrafterAnalysis?.customMade ?? [];
    final postCustomized = _handcrafterAnalysis?.postCustomized ?? [];
    final readyMade = _handcrafterAnalysis?.readyMade ?? [];

    final periodSet = <String>{};
    periodSet.addAll(visits.map((v) => v['period'] as String));
    periodSet.addAll(customMade.map((v) => v['period'] as String));
    periodSet.addAll(postCustomized.map((v) => v['period'] as String));
    periodSet.addAll(readyMade.map((v) => v['period'] as String));
    _allPeriods = periodSet.toList()..sort();

    return List.generate(_allPeriods.length, (index) {
      final period = _allPeriods[index];

      final view = (visits.firstWhere((v) => v['period'] == period,
          orElse: () => {'count': 0})['count'] ??
          0)
          .toDouble();
      final custom = (customMade.firstWhere((v) => v['period'] == period,
          orElse: () => {'revenue': 0})['revenue'] ??
          0)
          .toDouble();
      final post = (postCustomized.firstWhere((v) => v['period'] == period,
          orElse: () => {'revenue': 0})['revenue'] ??
          0)
          .toDouble();
      final ready = (readyMade.firstWhere((v) => v['period'] == period,
          orElse: () => {'revenue': 0})['revenue'] ??
          0)
          .toDouble();

      double total = view + custom + post + ready;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            width: 20,
            borderRadius: BorderRadius.circular(6),
            color: SizeConfig.iconColor,
          ),
        ],
      );
    });
  }

  Future<void> _loadData(BuildContext context) async {
    try {
      final handcrafterAnalysis = await hvm.fetchHandcrafterAnalysis(interval);
      setState(() {
        _handcrafterAnalysis = handcrafterAnalysis;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading Analysis")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double totalRevenue = (_handcrafterAnalysis?.totalCustom ?? 0) +
        (_handcrafterAnalysis?.totalPost ?? 0) +
        (_handcrafterAnalysis?.totalReady ?? 0);

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
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: SizeConfig.textRatio * 15),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Analysis',
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 20 * SizeConfig.textRatio,
            )),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 16 * SizeConfig.verticalBlock,
                  left: 16 * SizeConfig.verticalBlock,
                  top: 16 * SizeConfig.horizontalBlock,
                  bottom: 50 * SizeConfig.horizontalBlock,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dashboard",
                        style: GoogleFonts.rubik(
                          fontSize: 24 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 10 * SizeConfig.verticalBlock),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20 * SizeConfig.textRatio),
                      decoration: BoxDecoration(
                        color: Color(0xFFE9E9E9).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_handcrafterAnalysis?.totalVisit ?? 0}',
                            style: GoogleFonts.rubik(
                              fontSize: 24 * SizeConfig.textRatio,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Views",
                            style: GoogleFonts.rubik(
                              fontSize: 16 * SizeConfig.textRatio,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30 * SizeConfig.verticalBlock),
                    // Revenue Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20 * SizeConfig.textRatio),
                      decoration: BoxDecoration(
                        color: Color(0xFFE9E9E9).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20 * SizeConfig.textRatio),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E9E9).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Revenue Breakdown",
                              style: GoogleFonts.rubik(
                                fontSize: 18 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10 * SizeConfig.verticalBlock),

                            // Custom Made
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Custom Made",
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_handcrafterAnalysis?.totalCustom?.toStringAsFixed(2) ?? "0.00"} LE',
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8 * SizeConfig.verticalBlock),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Post Customized",
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_handcrafterAnalysis?.totalPost?.toStringAsFixed(2) ?? "0.00"} LE',
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8 * SizeConfig.verticalBlock),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ready Made",
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_handcrafterAnalysis?.totalReady?.toStringAsFixed(2) ?? "0.00"} LE',
                                  style: GoogleFonts.rubik(
                                    fontSize: 16 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 30, thickness: 1),
                            Text("Statistics",
                                style: GoogleFonts.rubik(
                                  fontSize: 18 * SizeConfig.textRatio,
                                  fontWeight: FontWeight.bold,
                                )),
                            Container(
                              height: 300 * SizeConfig.verticalBlock,
                              padding: EdgeInsets.all(15 * SizeConfig.verticalBlock),
                              child: BarChart(
                                BarChartData(
                                  barGroups: _buildBarGroups(),
                                  gridData: FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index < 0 ||
                                              index >= _allPeriods.length)
                                            return const SizedBox();
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: Text(
                                                _allPeriods[index].substring(5),
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20 * SizeConfig.verticalBlock),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        width: 120 * SizeConfig.horizontalBlock,
                        decoration: BoxDecoration(
                          color: SizeConfig.iconColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: SizeConfig.iconColor,
                          style: TextStyle(color: Colors.white),
                          iconDisabledColor:  Colors.white,
                          iconEnabledColor:  Colors.white,
                          value: interval,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: "DAYS", child: Text("Daily")),
                            DropdownMenuItem(value: "WEEKS", child: Text("Weekly")),
                            DropdownMenuItem(value: "MONTHS", child: Text("Monthly")),
                          ],
                          onChanged: (value) {
                            if (value != null && value != interval) {
                              setState(() {
                                interval = value;
                                _isLoading = true;
                              });
                              _loadData(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
