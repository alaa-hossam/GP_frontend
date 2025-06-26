import 'package:gp_frontend/Models/BazarModel.dart';

class BazarViewModel{
  BazarService ApiService = BazarService();

  Future<BazarModel> getActiveBazar()async{
    return await ApiService.getActiveBazar();
  }

  getBazarProducts(String id){
    return ApiService.getBazarProducts(id);
  }
}