import 'package:gp_frontend/Models/orderModel.dart';
import 'package:gp_frontend/ViewModels/orderViewModel.dart';

class orderProvider{

  orderViewModel orderVM = orderViewModel();

  createPostOrder(orderModel order)async{
    await orderVM.createPostOrder(order);

  }
}