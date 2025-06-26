import 'package:gp_frontend/Models/handcrafterModel.dart';

class handcrafterViewModel {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  handcrafterService handcrafterSer = handcrafterService();


  Future<String> addHandcrafter({required profileImage,required name,required BIO,required nationalIdImage, required specializationsId})async{
    print("in HVMMMMMMMMMMMM");
    handcrafterModel handcrafter = handcrafterModel(name: name,profileImage: profileImage,description: BIO, specializationsId: specializationsId, nationalIdImage: nationalIdImage);
    print("in HVMMMMMMMMMMMM22222222222222222");
    return handcrafterSer.addHandcrafter(handcrafter);
  }
  Future<String> addHandcrafterReel({required content,required file})async{
    print("in HVMMMMMMMMMMMM");
    return handcrafterSer.addHandcrafterReel(content,file);
  }

  Future<handcrafterModel?> fetchHandcrafter() async {
    return handcrafterSer.getHandcrafter();
  }
  Future<handcrafterModel?> fetchHandcrafterById(String Id) async {
    return handcrafterSer.getHandcrafterById(Id);
  }
}
