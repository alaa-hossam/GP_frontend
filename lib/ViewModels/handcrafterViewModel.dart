import 'dart:convert';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:gp_frontend/Models/handcrafterModel.dart';
import 'package:http/http.dart' as http;

class handcrafterViewModel {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  handcrafterService handcrafterSer = handcrafterService();


  Future<String> addHandcrafter({required profileImage,required name,required BIO,required nationalIdImage, required specializationsId})async{
    print("in HVMMMMMMMMMMMM");
    handcrafterModel handcrafter = handcrafterModel(name,profileImage,BIO, specializationsId, nationalIdImage);
    print("in HVMMMMMMMMMMMM22222222222222222");
    return handcrafterSer.addHandcrafter(handcrafter);
  }

}
