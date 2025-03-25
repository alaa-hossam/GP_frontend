import 'package:gp_frontend/Models/BackageModel.dart';

class BackagesViewModel{
  BackagesServices ApiService = BackagesServices();

  getAllBackages(){
    return ApiService.getBackages();
  }
}