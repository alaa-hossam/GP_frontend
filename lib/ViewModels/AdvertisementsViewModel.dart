import 'package:flutter/cupertino.dart';

import '../Models/AdvertisementModel.dart';

class AdvertisementsViewModel extends ChangeNotifier {
  final AdvertisementApiServices apiServices = AdvertisementApiServices();
  List<AdvertisementsModel> _ads = [];

  List<AdvertisementsModel> get ads => _ads;

  void fetchAds() {
    _ads = apiServices.getAds();
    notifyListeners(); // Notify the UI about changes
  }
}


