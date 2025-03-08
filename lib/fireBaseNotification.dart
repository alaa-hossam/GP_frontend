import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationFire{
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> initNotification()async{
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print("FirebaseToken: + $token");
    return token;
  }
}