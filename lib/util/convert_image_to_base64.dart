import 'dart:convert';

import 'dart:io';

class ConvertImageToBase64{
  static String convert(File? imageFile) {
    if (imageFile != null) {
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      return base64Image;
    } else {
      return '';
    }
  }
}