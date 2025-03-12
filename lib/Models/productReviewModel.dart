import 'package:intl/intl.dart';


class productReviewModel {
  String _comment, _userId,_createAt;
  double _rate;
  productReviewModel(this._userId, this._comment,this._createAt, this._rate,);


  get rate => _rate;

  get comment => _comment;

  get createAt {
    DateTime dateTime = DateTime.parse(_createAt);
    String formattedDate = DateFormat('dd MMM').format(dateTime);
    print(formattedDate);
    return formattedDate;
  }

  get userId => _userId;
}