import 'dart:io';

import '../Models/AdvertisementModel.dart';

class AdvertisementsViewModel {
  final AdvertisementApiServices apiServices = AdvertisementApiServices();
  List<AdvertisementsModel> _ads = [];

  List<AdvertisementsModel> get ads => _ads;

  addAdvertisement(File? image , String? Url , String? packageId , String? transactionId) {
    return apiServices.addAdvertisement(image, Url, packageId, transactionId);
  }
  getAdvertisement() async{
    _ads = await apiServices.getAds();
    return _ads;

  }
}


