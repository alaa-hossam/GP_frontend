import 'dart:io';

class AdvertisementsModel {
  String _image;
  String _link;


  String get image => _image;

  AdvertisementsModel(this._image, this._link);


  String get link => _link;
}

class AdvertisementApiServices {
  List<AdvertisementsModel> getAds() {
    return [
      AdvertisementsModel("assets/images/BPM.png", "https://google.com"),
      AdvertisementsModel("assets/images/Screenshot 2024-05-17 110110.png", "https://chatgpt.com"),
      AdvertisementsModel("assets/images/BPM.png", "https://google.com"),
    ];
  }
}

