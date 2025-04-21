
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/views/addAddress.dart';

class AddressViewModel {
  final AddressService apiServices = AddressService();
  List<AddressModel> _addresses = [];

  List<AddressModel> get ads => _addresses;

  addAddress(AddressModel address) {
    apiServices.addAddresses(address);
  }
  getAddresses() async{
    _addresses = await apiServices.getAddresses();
    return _addresses;

  }
}