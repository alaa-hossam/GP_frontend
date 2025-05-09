import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/Models/voucherModel.dart';

class voucherViewModel  extends ChangeNotifier{
  final voucherService apiServices = voucherService();

  Future<List<voucherModel>> fetchVouchers() async {
    return await apiServices.getVouchers();
  }
  Future<voucherModel> fetchVoucher(String code) async {
    return await apiServices.getspecificVouchers(code);
  }



}
