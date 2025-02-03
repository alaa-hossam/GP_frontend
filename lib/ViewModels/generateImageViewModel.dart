import 'package:gp_frontend/Models/generateImageModel.dart';

class generateImageViewModel {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  generateImageServices generateImageProcesses = generateImageServices();

  Future<String> generateImage({required prompt})async{
    return generateImageProcesses.generateImage(prompt);
  }

  Future<String> saveGeneratedImage({required String prompt, required String imagePath}) async {
    generateImageModel generatedImage = generateImageModel(prompt: prompt, imageUrl: imagePath);
    return generateImageProcesses.saveGeneratedImage(generatedImage);
  }

}