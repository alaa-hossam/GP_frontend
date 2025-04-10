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

  // AdvertisementProvider({required this.AdsVM});

  int get currentIndex => _currentIndex;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (AdsVM.ads.isEmpty) return;

      int nextPage = _currentIndex + 1;
      if (nextPage >= AdsVM.ads.length) {
        nextPage = 0;
      }

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      startAutoScroll();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  getAdvertisement() async {
    print("Fetching advertisements...");
    ads = await AdsVM.getAdvertisement();
    notifyListeners();

    // Start auto-scrolling after loading ads
    startAutoScroll();
  }
}
