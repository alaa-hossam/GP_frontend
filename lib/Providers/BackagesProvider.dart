import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/ViewModels/BackagesViewModel.dart';

import '../Models/BackageModel.dart';

class BackagesProvider extends ChangeNotifier{
  BackagesViewModel BackVM = BackagesViewModel();
  List<Backages> myBackages =[] ;
  getAllBackages(){
    myBackages = BackVM.getAllBackages();
    notifyListeners();
  }
}