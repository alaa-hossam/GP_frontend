import 'package:flutter/foundation.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/ViewModels/AddressViewModel.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';

class AddressProvider extends ChangeNotifier{
  List<AddressModel> addresses = [];
  AddressViewModel AddressVM = AddressViewModel();

  getAddresses() async {
    print("Fetching Addresses...");
    addresses = await AddressVM.getAddresses();
    print(addresses);
    notifyListeners();
  }

}