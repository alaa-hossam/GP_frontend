import 'package:gp_frontend/Models/offerModel.dart';

class offerViewModel{
  offerService APIService = offerService();
  Future<List<offerModel>> fetchOffers(postId)async{
    return await APIService.getOffers(postId);
  }
  Future<bool> addOffer(offerModel offer , String postId)async{
    return await APIService.addOffer(offer, postId);
  }
}