import '../Models/orderModel.dart';

class orderViewModel{
  orderService ApiService = orderService();

  createPostOrder(orderModel order)async{
    await ApiService.createOrderByPost(order);
  }
}