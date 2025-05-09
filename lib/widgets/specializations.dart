// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'Dimensions.dart';
// class specializations extends StatefulWidget {
//   const specializations({super.key});
//
//   @override
//   State<specializations> createState() => _specializationsState();
// }
//
// class _specializationsState extends State<specializations> {
//   List<String> tempSelectedSpecializations = [];
//   List<String> tempSelectedSpecializationsID = [];
//
//   // Add this method
//   void _openSpecializationsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         // Use a separate list for temporary selections inside the bottom sheet
//         List<String> localSelectedSpecs = List.from(tempSelectedSpecializations);
//         List<String> localSelectedSpecsID = List.from(tempSelectedSpecializationsID);
//
//         return Container(
//             height: 541 * SizeConfig.verticalBlock,
//             width: 361 * SizeConfig.horizontalBlock,
//             padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
//             child: Column(
//               children: [
//                 Container(
//                   width: 56 * SizeConfig.horizontalBlock,
//                   height: 1 * SizeConfig.verticalBlock,
//                   color: SizeConfig.iconColor,
//                 ),
//                 Text(
//                   "Specializations",
//                   style: TextStyle(
//                     fontSize: 24 * SizeConfig.textRatio,
//                     fontFamily: "Roboto",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: FutureBuilder<List<dynamic>>(
//                     future: _fetchSpecializations(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(child: Text("Error fetching specializations"));
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return Center(child: Text("No specializations found"));
//                       }
//
//                       final specializations = snapshot.data!;
//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         itemCount: specializations.length,
//                         itemBuilder: (context, index) {
//                           final specialization = specializations[index];
//                           final isSelected = localSelectedSpecs.contains(specialization.name);
//
//                           return CheckboxListTile(
//                             title: Text(specialization.name),
//                             value: isSelected,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 if (value == true) {
//                                   if (!localSelectedSpecs.contains(specialization.name)) {
//                                     localSelectedSpecs.add(specialization.name);
//                                     localSelectedSpecsID.add(specialization.id);
//                                   }
//                                 } else {
//                                   localSelectedSpecs.remove(specialization.name);
//                                   localSelectedSpecsID.remove(specialization.id);
//                                 }
//                               });
//                             },
//                             activeColor: Colors.green,
//                             checkColor: Colors.white,
//                             tileColor: isSelected ? Colors.green.withOpacity(0.2) : null,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               side: isSelected
//                                   ? BorderSide(color: Colors.green, width: 2)
//                                   : BorderSide(color: Colors.transparent),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 customizeButton(
//                   buttonName: 'Select',
//                   buttonColor: Color(0xFF5095B0),
//                   fontColor: const Color(0xFFF5F5F5),
//                   onClickButton: () {
//                     setState(() {
//                       tempSelectedSpecializations = List.from(localSelectedSpecs);
//                       tempSelectedSpecializationsID = List.from(localSelectedSpecsID);
//                     });
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             );
//         );
//       },
//     );
//   }
//
//   Future<List<dynamic>> _fetchSpecializations() async {
//     // Your implementation here
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Specializations")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _openSpecializationsBottomSheet(context),
//           child: Text("Open Specializations"),
//         ),
//       ),
//     );
//   }
// }