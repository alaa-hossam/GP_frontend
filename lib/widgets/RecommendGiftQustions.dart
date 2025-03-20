// import 'package:flutter/material.dart';
//
// import 'Dimensions.dart';
//
// class RecommendGiftQustions extends StatelessWidget {
//   final String qustion;
//   final List<String> answers;
//   RecommendGiftQustions({
//     required this.qustion,
//     required this.answers,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       spacing: 15 * SizeConfig.verticalBlock,
//       children: [
//         Text(
//           qustion,
//           style: TextStyle(
//             fontSize: 32 * SizeConfig.textRatio,
//             color: Colors.black,
//             fontFamily: "Roboto",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//     Text(
//     "choose one option",
//     style: TextStyle(
//     fontSize: 20 * SizeConfig.textRatio,
//     color: Colors.black,
//     fontFamily: "Roboto",
//     ),
//       ],
//     );
//   }
// }
