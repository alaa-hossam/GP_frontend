import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/orderModel.dart';
import 'package:gp_frontend/ViewModels/orderViewModel.dart';

class orderProvider extends ChangeNotifier{

  orderViewModel orderVM = orderViewModel();

  createPostOrder(orderModel order)async{
    return await orderVM.createPostOrder(order);

  }

  createReadyOrder(orderModel order , String? giftCode ,bool fromBazar)async{
    return await orderVM.createReadyOrder(order ,giftCode ?? "", fromBazar );

  }
  createCustomOrder(orderModel order , String? giftCode ,bool fromBazar)async{
    return await orderVM.createCustomOrder(order ,giftCode ?? "", fromBazar );

  }
  Future<List<Map<String , dynamic>>> getOrders() async{
    return await orderVM.getOrders();
  }
}