import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/productDetails.dart';

class CustomizeFinalProduct extends StatelessWidget {
  final String mainImage, id;
  final double? quantity, duration;
  final double price;
  final Map<String, dynamic> variations; // 👈 Add this

  const CustomizeFinalProduct(
      this.mainImage,
      this.price,
      this.id, {
        required this.variations, // 👈 required
        this.quantity,
        this.duration,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * SizeConfig.horizontalBlock,
        vertical: 5 * SizeConfig.verticalBlock,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                mainImage,
                width: 120 * SizeConfig.horizontalBlock,
                height: 120 * SizeConfig.verticalBlock,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Right info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  variationRow('Quantity', '${quantity?.toInt() ?? 0} Items'),
                  variationRow('Duration', '${duration?.toInt() ?? 0} Days'),
                  variationRow('Price', '${price.toStringAsFixed(0)} LE'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8 * SizeConfig.verticalBlock,
                    runSpacing: 6 * SizeConfig.verticalBlock,
                    children: variations.entries.map((entry) {
                      final type = entry.key.toLowerCase();
                      final value = entry.value;
                      if (type == "color") {
                        return CircleAvatar(
                          radius: 10,
                          backgroundColor: _parseColor(value),
                        );
                      } else {
                        return variationTag('$type: $value');
                      }
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget variationRow(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label: '),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      style: GoogleFonts.rubik(fontSize: 13),
    );
  }

  Color _parseColor(String colorValue) {
    try {
      return Color(int.parse('0xFF$colorValue'));
    } catch (_) {
      return Colors.grey;
    }
  }
}

Widget variationTag(String text, {Color? bgColor, Color textColor = Colors.black}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor ?? Colors.grey.shade300,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: textColor),
    ),
  );
}

