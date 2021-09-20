import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class AddMenu extends StatefulWidget {
  final bool _isUpdate;
  final MenuData? menuData;

  const AddMenu(this._isUpdate, {Key? key, this.menuData}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState(this._isUpdate);
}

class _AddMenuState extends State<AddMenu> {
  final bool _isUpdate;

  _AddMenuState(this._isUpdate);

  final _picker = ImagePicker();
  File? _pickedImage;

  // String? _pickedImageBase64;
  var _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      _nameController.text = widget.menuData?.name ?? '';
      _priceController.text = widget.menuData?.price.toString() ?? '';
      _descriptionController.text = widget.menuData?.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu'),
        brightness: Brightness.dark,
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _imageInput(context),
                Positioned(
                  top: _getPositionButtonImage(context),
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      _displayOptionsDialog();
                    },
                    child: Text(_getImageString()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: ColorPalette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Menu Name',
                        hintText: 'Pasta',
                        hintStyle: TextStyle(
                          color: ColorPalette.primaryColorLight,
                        ),
                        labelStyle: TextStyle(
                          color: ColorPalette.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorPalette.primaryColor,
                      ),
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Menu Name is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Menu Price',
                        hintText: '12.000',
                        hintStyle: TextStyle(
                          color: ColorPalette.primaryColorLight,
                        ),
                        labelStyle: TextStyle(
                          color: ColorPalette.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorPalette.primaryColor,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _priceController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Price is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Menu Description',
                        hintText: 'pasta is italian food',
                        hintStyle: TextStyle(
                          color: ColorPalette.primaryColorLight,
                        ),
                        labelStyle: TextStyle(
                          color: ColorPalette.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorPalette.primaryColor,
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: _descriptionController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Menu Description is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PrimaryColorButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        var form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          if (_pickedImage != null) {
                            form.save();
                            if (_isUpdate) {
                              _updateData();
                            } else {
                              _inputData();
                            }
                          } else {
                            if (_isUpdate) {
                              _updateData();
                            } else {
                              CustomDialog.showDialogWithoutTittle(
                                  'Please set the menu image');
                            }
                          }
                        }
                      },
                      textTitle: _isUpdate ? 'Update Menu' : 'Input Menu',
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width * 0.1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getPositionButtonImage(BuildContext context) {
    if (_pickedImage == null) {
      if (_isUpdate) {
        if (widget.menuData?.imageUrl == null) {
          return MediaQuery.of(context).size.width * 0.25;
        } else {
          return MediaQuery.of(context).size.width * 0.45;
        }
      } else {
        return MediaQuery.of(context).size.width * 0.25;
      }
    } else {
      return MediaQuery.of(context).size.width * 0.45;
    }
  }

  String _getImageString() {
    if (_pickedImage == null) {
      if (_isUpdate) {
        if (widget.menuData?.imageUrl == null) {
          return 'Set Image';
        } else {
          return 'Change Image';
        }
      } else {
        return 'Set Image';
      }
    } else {
      return 'Change Image';
    }
  }

  Container _imageInput(BuildContext context) {
    if (_isUpdate && _pickedImage == null) {
      return Container(
        color: ColorPalette.primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.6,
        child: Image.network(
          widget.menuData?.imageUrl ?? '',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        color: ColorPalette.primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.6,
        child: _pickedImage != null
            ? Image.file(
                _pickedImage!,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.cover,
              )
            : SizedBox(),
      );
    }
  }

  void _inputData() {
    CustomDialog.showLoading();
    MenuInteractor.insertNewMenu(
            MenuData(
                name: _nameController.text,
                description: _descriptionController.text,
                price: int.tryParse(_priceController.text) ?? 0,
                imageUrl: ''),
            _pickedImage?.absolute.path ?? '')
        .then((value) {
      Navigator.pop(context);
      print('Input Data Response ${jsonEncode(value)}');
      CustomDialog.showDialogWithoutTittle('Success Input ${value.name}')
          .then((value) {
        Navigator.pop(context, true);
      });
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }

  void _updateData() {
    CustomDialog.showLoading();
    String? filePath =
        _pickedImage != null ? _pickedImage?.absolute.path : null;
    MenuInteractor.updateMenu(
            widget.menuData?.menuId ?? '',
            MenuData(
                name: _nameController.text,
                description: _descriptionController.text,
                price: int.tryParse(_priceController.text) ?? 0,
                imageUrl: filePath == null ? widget.menuData?.imageUrl : ''),
            filePath)
        .then((value) {
      Navigator.pop(context);
      print('Update Data Response ${jsonEncode(value)}');
      CustomDialog.showDialogWithoutTittle('Success Update ${value.name}')
          .then((value) {
        Navigator.pop(context, true);
      });
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }

  void _displayOptionsDialog() async => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext buildContext) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Take a photo'),
                onPressed: () {
                  _getImage(ImageSource.camera);
                },
              ),
              CupertinoDialogAction(
                child: Text('Choose image from gallery'),
                onPressed: () {
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
            cancelButton: CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Choose Image Source'),
          );
        },
      );

  void _getImage(ImageSource imageSource) async {
    Navigator.pop(context);
    CustomDialog.showLoading();
    var pickedImage = await _picker
        .pickImage(
      source: imageSource,
      imageQuality: 50,
      maxHeight: 1080,
      maxWidth: 1080,
    )
        .whenComplete(() {
      Navigator.pop(context);
    });

    if (pickedImage != null) {
      CropImage.crop(
              File(pickedImage.path), CropAspectRatio(ratioX: 16, ratioY: 9))
          .then((croppedFile) {
        if (croppedFile != null) {
          print('Cropped Image Path ${croppedFile.path}');
          setState(() {
            _pickedImage = croppedFile;
            // _pickedImageBase64 = ConvertImageToBase64.convert(croppedFile);
          });
        }
      });
    }
  }
}
