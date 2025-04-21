import 'package:flutter/foundation.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/ViewModels/AddressViewModel.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/addAddress.dart';

class AddressProvider extends ChangeNotifier{
  List<AddressModel> addresses = [];
  AddressViewModel AddressVM = AddressViewModel();

  addAddress(AddressModel address)async{
    AddressVM.addAddress(address);
    getAddresses();
  }

  getAddresses() async {
    print("Fetching Addresses...");
    addresses = await AddressVM.getAddresses();
    print(addresses);
    notifyListeners();
  }

}