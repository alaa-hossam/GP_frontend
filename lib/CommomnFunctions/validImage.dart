
class ValidateImage{
  String? getValidImageUrl(String? imageUrl) {
    print("herrrrrrrrrrre");
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(imageUrl);
      if (uri.hasAbsolutePath && !imageUrl.contains('http', 10)) {
        return imageUrl;
      } else {
        print("Invalid image URL detected: $imageUrl");
        return null;
      }
    } catch (e) {
      print("Failed to parse image URL: $imageUrl");
      return null;
    }
  }
}

