import 'package:gp_frontend/Models/offerModel.dart';

class offerViewModel{
  offerService APIService = offerService();
  Future<List<offerModel>> fetchOffers(postId)async{
    return await APIService.getOffers(postId);
  }
}