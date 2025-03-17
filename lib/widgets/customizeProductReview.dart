import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:intl/intl.dart';

class CustomizeProductReview extends StatelessWidget {
  final String userId;
  final String comment;
  final double rate;
  final String createAt;
  late customerViewModel CVM;

  CustomizeProductReview({required this.userId,required this.comment,required this.rate,required this.createAt});

  get _createAt {
    DateTime dateTime = DateTime.parse(this.createAt);
    String formattedDate = DateFormat('dd MMM').format(dateTime);
    print(formattedDate);
    return formattedDate;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerModel?>(
      future: CVM.fetchUser(userId), // Fetch the customer data (may return null)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if something went wrong
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Handle the case where no data is returned
          return Center(child: Text("No user data found"));
        }

        // Once the data is fetched, use it to build the UI
        final customer = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(5),
          height: SizeConfig.verticalBlock * 135,
          width: SizeConfig.horizontalBlock * 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: SizeConfig.iconColor),
          ),
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: Image.network(
                    customer.profileImage ?? '', // Use a fallback if profileImage is null
                    width: 40 * SizeConfig.horizontalBlock,
                    height: 40 * SizeConfig.verticalBlock,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 50);
                    },
                  ),
                ),
                title: Text(
                  customer.name ?? 'Unknown User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto",
                    fontSize: 16 * SizeConfig.textRatio,
                  ),
                ),
                subtitle: Text(
                  _createAt,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 12 * SizeConfig.textRatio,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    // Fill stars based on review.rate
                    if (index < rate) {
                      return Icon(
                        Icons.star,
                        color: Color(0xFFD4931C), // Gold color for filled stars
                        size: 16 * SizeConfig.textRatio,
                      );
                    } else {
                      return Icon(
                        Icons.star_border,
                        color: Color(0xFFD4931C), // Gold color for outlined stars
                        size: 16 * SizeConfig.textRatio,
                      );
                    }
                  }),
                ),
              ),
              // Add more widgets to display other review details
            ],
          ),
        );
      },
    );
  }
}