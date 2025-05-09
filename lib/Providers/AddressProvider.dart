import 'package:flutter/foundation.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/ViewModels/AddressViewModel.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/addAddress.dart';

class AddressProvider extends ChangeNotifier{
  List<AddressModel> addresses = [];
  AddressViewModel AddressVM = AddressViewModel();
  bool isLoading = false;

  addAddress(AddressModel address)async{
    AddressVM.addAddress(address);
    getAddresses();
  }

  getAddresses() async {
    isLoading = true;
    addresses = await AddressVM.getAddresses();
    isLoading = false;
    notifyListeners();
  }

}