import 'package:gp_frontend/Models/offerModel.dart';

class offerViewModel{
  offerService APIService = offerService();
  Future<List<offerModel>> fetchOffers(postId)async{
    return await APIService.getOffers(postId);
  }
  Future<bool> addOffer(offerModel offer , String postId)async{
    return await APIService.addOffer(offer, postId);
  }

  Future<bool> updateOffer(offerModel offer)async{
    bool update = await APIService.updateOffer(offer);
    return update;
  }
  Future<bool> deleteOffer(String offerId)async{
    bool delete = await APIService.deleteOffer(offerId);
    return delete;
  }
}