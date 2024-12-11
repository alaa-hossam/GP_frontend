import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CustomerModel {
  String userName;
  String name;
  String password;
  String email;
  String phone;
  String role = "Client";
  bool isActive = false;
  bool isVerified = false;
  String gender;
  String? deviceToken;
  DateTime birthDate;
  DateTime? lastActive;

  CustomerModel(this.name,this.userName, this.password, this.email, this.phone,
      this.gender, this.birthDate);



  Future<String> getDeviceToken() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId;
    if (await deviceInfo.deviceInfo is AndroidDeviceInfo) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? "unknown";
    } else if (await deviceInfo.deviceInfo is IosDeviceInfo) {
      IosDeviceInfo IosInfo = await deviceInfo.iosInfo;
      deviceId = IosInfo.identifierForVendor ?? "unknown";
    } else {
      deviceId = "Unknown Device";
    }
    var bytes = utf8.encode(deviceId);
    String token = sha256.convert(bytes).toString();
    return token;
  }
}
