import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/views/AddAdvertisement.dart';

import '../Models/AdvertisementModel.dart';

class AdvertisementsViewModel extends ChangeNotifier {
  final AdvertisementApiServices apiServices = AdvertisementApiServices();
  List<AdvertisementsModel> _ads = [];

  List<AdvertisementsModel> get ads => _ads;

  // addAdvertisement(File? image , String? Url , String? packageId , String? transactionId) {
  //   return apiServices.addAdvertisement(image, Url, packageId, transactionId);
  // }
  getAdvertisement() async{
    await apiServices.getAds();
  }
}


