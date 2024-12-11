import 'package:flutter/cupertino.dart';

import '../Models/AdvertisementModel.dart';

class AdvertisementsViewModel extends ChangeNotifier{
  List<AdvertisementsModel> _Advertisements = [];

  List<AdvertisementsModel> get Advertisements => _Advertisements;
  final AdvertisementApiServices apiServices= AdvertisementApiServices();
  List<AdvertisementsModel> _ads = [];

  List<AdvertisementsModel> get ads => _ads;

  fetchProducts(){
    _Advertisements = apiServices.getAds();
  }
}


