import 'package:gp_frontend/Models/BackageModel.dart';

class BackagesViewModel{
  BackagesServices ApiService = BackagesServices();

  Future<List<Backages>> getAllBackages()async{
    return await ApiService.getBackages();
  }
}