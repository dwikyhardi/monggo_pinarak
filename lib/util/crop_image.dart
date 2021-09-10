import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class CropImage {
  static Future<File?> crop(
      File imageFile, CropAspectRatio cropAspectRatio) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        cropStyle: CropStyle.rectangle,
        aspectRatio: cropAspectRatio,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.ratio16x9]
            : [CropAspectRatioPreset.ratio16x9],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            backgroundColor: Colors.grey,
            toolbarColor: ColorPalette.primaryColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            cropGridColor: ColorPalette.primaryColorDark,
            showCropGrid: false,
            cropFrameColor: ColorPalette.secondaryColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: '',
          resetButtonHidden: true,
          rotateButtonsHidden: true,
          resetAspectRatioEnabled: false,
          rotateClockwiseButtonHidden: true,
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          cancelButtonTitle: '',
          showCancelConfirmationDialog: true,
          aspectRatioPickerButtonHidden: true,
          aspectRatioLockDimensionSwapEnabled: false,
        ));

    return croppedFile;
  }
}
