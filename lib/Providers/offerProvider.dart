import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/offerModel.dart';
import 'package:gp_frontend/ViewModels/offerViewModel.dart';

class offerProvider extends ChangeNotifier{
  List<offerModel> offers = [];
  offerViewModel offerVM = offerViewModel();

  getOffers(String postId)async{
    offers = await offerVM.fetchOffers(postId);
    notifyListeners();
  }

  addOffer(offerModel offer){

  }


}