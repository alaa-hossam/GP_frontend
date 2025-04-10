import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/AdvertisementModel.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';

// class AdvertisementProvider extends ChangeNotifier{
//   AdvertisementsViewModel AVM = AdvertisementsViewModel();
//
//   getAdvertisement(File image , String Url , String packageId , String transactionId){
//     AVM.fetchAds(image, Url, packageId, transactionId);
//     notifyListeners();
//   }
//
// }

class AdvertisementProvider with ChangeNotifier {
  List<AdvertisementsModel> ads = [];
  AdvertisementsViewModel AdsVM = AdvertisementsViewModel();
  final PageController pageController = PageController();
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Timer? _autoScrollTimer;

  AdvertisementProvider() {
    pageController.addListener(() {
      int newIndex = pageController.page?.round() ?? 0;
      if (newIndex != _currentIndex) {
        _currentIndex = newIndex;
        notifyListeners();
      }
    });
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void startAutoScroll() {
    _autoScrollTimer?.cancel(); // prevent duplicates

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (ads.isEmpty) return;

      int nextPage = _currentIndex + 1;
      if (nextPage >= ads.length) {
        nextPage = 0;
      }

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }


  getAdvertisement() async {
    print("Fetching advertisements...");
    ads = await AdsVM.getAdvertisement();
    print(ads);
    notifyListeners();
    startAutoScroll();
  }
}
