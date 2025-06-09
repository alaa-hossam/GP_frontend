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

  Future<bool> addOffer(offerModel offer , String postId)async{
    bool response =  await offerVM.addOffer(offer, postId);
    print("..................");
    notifyListeners();
    return response;
  }


}