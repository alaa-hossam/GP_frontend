import 'package:flutter/foundation.dart';
import 'package:gp_frontend/Models/voucherModel.dart';
import 'package:gp_frontend/ViewModels/voucherViewModel.dart';

class voucherProvider extends ChangeNotifier{
  List<voucherModel> vouchers = [];
   voucherModel voucher = voucherModel(code: "", amount: 0, type: "", id: "");
  voucherViewModel voucherVM = voucherViewModel();


  getVouchers() async {
    vouchers = await voucherVM.fetchVouchers();
    notifyListeners();
  }
  getVoucher(String code) async {
    voucher = await voucherVM.fetchVoucher(code);
    notifyListeners();
  }

  void resetVoucher({bool notify = true}) {
    voucher = voucherModel(code: "", amount: 0, type: "", id: "");

    if (notify) {
      notifyListeners();
    }
  }


}