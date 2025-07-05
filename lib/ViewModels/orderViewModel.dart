import '../Models/orderModel.dart';

class orderViewModel{
  orderService ApiService = orderService();

  createPostOrder(orderModel order)async{
    return await ApiService.createOrderByPost(order);
  }

  createReadyOrder(orderModel order , String? giftCode ,bool fromBazar )async{
    return await ApiService.createReadyOrder(order ,giftCode ?? "", fromBazar );

  }
  createCustomOrder(orderModel order , String? giftCode ,bool fromBazar )async{
    return await ApiService.createCustomOrder(order ,giftCode ?? "", fromBazar );

  }

  Future<List<Map<String , dynamic>>> getOrders() async{
    return await ApiService.getOrders();
  }
  Future<List<Map<String , dynamic>>> getCrafterOrders() async{
    print("getCrafterOrders in VMMMM");
    return await ApiService.getCrafterOrders();
  }
}