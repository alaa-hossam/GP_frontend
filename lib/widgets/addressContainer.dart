// AddressItem.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import '../widgets/Dimensions.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressItem({
    Key? key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 98 * SizeConfig.verticalBlock,
        width: 345 * SizeConfig.horizontalBlock,
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 2 * SizeConfig.textRatio : 0,
            color: isSelected ? SizeConfig.iconColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(5 * SizeConfig.horizontalBlock),
          color: isSelected ? const Color(0xFFE9E9E9) : Colors.transparent,
          boxShadow: const [
            BoxShadow(
              color: Color(0x25000000),
              offset: Offset(1.0, 3.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Color(0xFFE9E9E9),
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5 * SizeConfig.verticalBlock),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 24 * SizeConfig.textRatio,
                ),
              ),
              SizedBox(width: 10 * SizeConfig.horizontalBlock),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.AddressOwner,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 20 * SizeConfig.textRatio,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.verticalBlock),
                  Text(
                    "${address.StreetName}, "
                        "${address.State.isNotEmpty ? '${address.State}, ' : ''}"
                        "${address.City}",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
