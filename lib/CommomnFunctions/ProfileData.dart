import 'package:flutter/material.dart';
import '../Models/CustomerModel.dart';
import '../Models/handcrafterModel.dart';
import '../ViewModels/customerViewModel.dart';
import '../ViewModels/handcrafterViewModel.dart';
import '../views/ProfileView.dart';
import '../views/MyHandcrafterProfile.dart';
import '../SqfliteCodes/Token.dart';

final cvm = customerViewModel();
final hvm = handcrafterViewModel();

Future<void> loadProfileByRole({
  required BuildContext context,
  void Function(CustomerModel customer)? onCustomerLoaded,
  void Function(handcrafterModel crafter)? onCrafterLoaded,
}) async {
  final token = Token();
  final role = await token.getRole() ?? "";

  // Show loading spinner
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    if (role == 'Handicrafter') {
      final crafter = await hvm.fetchHandcrafter();
      Navigator.pop(context); // Dismiss loading
      onCrafterLoaded?.call(crafter!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHandcrafterProfile(crafter!),
        ),
      );
    } else if (role == 'Client') {
      final customer = await cvm.fetchUserProfile();
      Navigator.pop(context); // Dismiss loading
      onCustomerLoaded?.call(customer!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(customer!),
        ),
      );
    } else {
      Navigator.pop(context); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unknown role")),
      );
    }
  } catch (e) {
    Navigator.pop(context); // Close loading if error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error loading profile")),
    );
  }
}
