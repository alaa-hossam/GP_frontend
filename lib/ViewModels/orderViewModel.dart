import '../Models/orderModel.dart';

class orderViewModel{
  orderService ApiService = orderService();

  createPostOrder(orderModel order)async{
    return await ApiService.createOrderByPost(order);
  }
}