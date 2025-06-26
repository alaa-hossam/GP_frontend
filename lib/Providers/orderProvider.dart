import 'package:gp_frontend/Models/orderModel.dart';
import 'package:gp_frontend/ViewModels/orderViewModel.dart';

class orderProvider{

  orderViewModel orderVM = orderViewModel();

  createPostOrder(orderModel order)async{
    return await orderVM.createPostOrder(order);

  }
}