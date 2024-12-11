import 'dart:io';

class AdvertisementsModel {
  File _image;
  String _link;
  List<AdvertisementsModel> _ads = [
    AdvertisementsModel(File("D:BPM.png"), "https://chat.openai.com/chat"),
    AdvertisementsModel(File("D:BPM.png"), "https://chat.openai.com/chat"),
    AdvertisementsModel(File("D:BPM.png"), "https://chat.openai.com/chat")
  ];

  AdvertisementsModel(this._image, this._link);

  List<AdvertisementsModel> get ads => _ads;
}

class AdvertisementApiServices{
  AdvertisementsModel? ads;
  getAds(){
    return ads?.ads;
}

}
