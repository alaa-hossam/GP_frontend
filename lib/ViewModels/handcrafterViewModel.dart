import 'package:gp_frontend/Models/handcrafterModel.dart';


class handcrafterViewModel {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  handcrafterService handcrafterSer = handcrafterService();


  Future<String> addHandcrafter({required profileImage,required name,required BIO,required nationalIdImage, required specializationsId})async{
    handcrafterModel handcrafter = handcrafterModel(name: name,profileImage: profileImage,description: BIO, specializationsId: specializationsId, nationalIdImage: nationalIdImage);
    return handcrafterSer.addHandcrafter(handcrafter);
  }
  Future<String> addHandcrafterReel({required content,required file})async{
    return handcrafterSer.addHandcrafterReel(content,file);
  }
  Future<String> changeProfileImage({required file})async{
    return handcrafterSer.changeImageProfile(file);
  }

  Future<handcrafterModel?> fetchHandcrafter() async {
    return handcrafterSer.getHandcrafter();
  }

  Future<handcrafterAnalysisModel?> fetchHandcrafterAnalysis(String interval) async {
    return handcrafterSer.getHandcrafterAnalysis(interval);
  }

  Future<handcrafterModel?> fetchHandcrafterById(String Id) async {
    return handcrafterSer.getHandcrafterById(Id);
  }
  Future<bool> deleteHandcrafterReel(String Id) async {
    return handcrafterSer.deleteHandCrafterPost(Id);
  }

}
