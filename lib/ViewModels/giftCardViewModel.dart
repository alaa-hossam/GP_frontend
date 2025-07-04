import 'package:gp_frontend/Models/giftCardModel.dart';


class giftCardViewModel {
  final giftCardService apiServices = giftCardService();


  buyGiftCard( String mail , double amount ,String message, String transactionId,) {
    giftCardModel card = giftCardModel(mail: mail, amount: amount, message: message);
    return apiServices.buyGiftCard(card, transactionId);
  }

}


