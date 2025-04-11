import 'dart:convert';

import 'package:http/http.dart' as http;


class paymentService {
  String baseUrl = "https://accept.paymob.com/api";
  String apiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBek5qa3dNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5RVGxhZHdnblR5QTZ6SGY2cUM0YTVhNU03aVhLSWJKVGk1Zl9hRGV2OV95UUt4c19SZXY1N0o1YVNONi1TVWNiYWQwM1NpaHI1ZGtsVjh0My1nYk1WQQ==";

  static const String integrationId = "5042932";
  static const String iframeId = "913134";

  // late Dio dio;
  // initDio() {
  //   dio = Dio(BaseOptions(
  //       baseUrl: baseUrl,
  //       headers: {'Content-type': "application/json"},
  //       receiveDataWhenStatusError: true));
  // }
  //
  // Future<int> getOrderId(
  //     {required String token, required String amount}) async {
  //   try {
  //     Response response = await dio.post(orderToken, data: {
  //       "auth_token": token,
  //       "delivery_needed": true,
  //       "amount_cent": amount,
  //       "currency": "EGP",
  //       "items": []
  //     });
  //     return response.data['token'];
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<int> getPaymentKey(
  //     {required String token, required String orderId, required String amount}) async {
  //   try {
  //     Response response = await dio.post(orderToken, data: {
  //       "auth_token": token,
  //       "delivery_needed": true,
  //       "amount_cent": amount,
  //       "currency": "EGP",
  //       "integration"
  //     });
  //     return response.data['token'];
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

   static Future<String> authenticate() async {
    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_key':"ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBek5qa3dNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5RVGxhZHdnblR5QTZ6SGY2cUM0YTVhNU03aVhLSWJKVGk1Zl9hRGV2OV95UUt4c19SZXY1N0o1YVNONi1TVWNiYWQwM1NpaHI1ZGtsVjh0My1nYk1WQQ=="}),
    );
    return jsonDecode(response.body)['token'];
  }

  static Future<int> createOrder(String token, double amountCents) async {
    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': token,
        'delivery_needed': false,
        'amount_cents': amountCents.toString(),
        'currency': 'EGP',
        'items': []
      }),
    );
    return jsonDecode(response.body)['id'];
  }

  static Future<String> generatePaymentKey(
      String token, double amountCents, int orderId) async {
    final billingData = {
      "apartment": "NA",
      "email": "test@example.com",
      "floor": "NA",
      "first_name": "Test",
      "street": "123 Street",
      "building": "NA",
      "phone_number": "+201000000000",
      "shipping_method": "PKG",
      "postal_code": "NA",
      "city": "Cairo",
      "country": "EG",
      "last_name": "User",
      "state": "NA"
    };

    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': token,
        'amount_cents': amountCents.toString(),
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': billingData,
        'currency': 'EGP',
        'integration_id': integrationId,
        'lock_order_when_paid': true
      }),
    );

    return jsonDecode(response.body)['token'];
  }
   static String getIframeUrl(String paymentToken) {
    return 'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=$paymentToken';
  }
}
