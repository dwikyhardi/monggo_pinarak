import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuViewModel {
  static CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  ///Get Method

  static Future<List<MenuData>> getMenuList() async {
    List<MenuData> menuDataList = <MenuData>[];
    await _menu.get().then((menuList) {
      menuList.docs.forEach((menuData) {
        if (menuData.exists && menuData.data() != null) {
          print(
              'Menu Object ${menuData.id} ======== ${jsonEncode(menuData.data())}');
          menuDataList.add(MenuData.fromJson(
              menuData.data() as Map<String, dynamic>,
              menuId: menuData.id));
        }
      });
    });

    return menuDataList;
  }

  static Future<MenuData> getDataMenu(String id) async {
    MenuData menuData = MenuData();
    await _menu.doc(id).get().then((value) {
      if (value.exists && value.data() != null) {
        menuData = MenuData.fromJson(value.data() as Map<String, dynamic>);
      } else {
        return Future.error("Data Menu Not Exist");
      }
    }).catchError((e) {
      return Future.error(e);
    });

    return menuData;
  }

  static Future<String> getDownloadUrl(String ref) async {
    return firebaseStorage.ref('$ref/image_$ref.jpg').getDownloadURL();
  }

  ///Insert Method

  static Future<MenuData> insertNewMenu(
      MenuData menuData, String filePath) async {
    MenuData menuDatas = MenuData();
    await _menu.add(menuData.toJson()).then((response) async {
      return await uploadPhotos(filePath, response.id).then((_) async {
        return await getDataMenu(response.id).then((value) async {
          return await updateDataMenu(
            response.id,
            MenuData(
              name: value.name,
              description: value.description,
              price: value.price,
              imageUrl: await getDownloadUrl(response.id),
            ),
          ).then((newData) {
            if (newData.name != null) {
              menuDatas = newData;
            } else {
              return Future.error('Error Input Data Menu');
            }
          }).catchError((e) {
            return Future.error(e);
          });
        }).catchError((e) {
          return Future.error(e);
        });
      }).catchError((e) {
        return Future.error(e);
      });
    }).catchError((e) {
      return Future.error(e);
    });

    return menuDatas;
  }

  static Future<void> uploadPhotos(String filePath, String ref) async {
    File _photosFile = File(filePath);
    try {
      await firebaseStorage
          .ref('$ref/image_$ref.jpg')
          .putFile(_photosFile)
          .then((value) {
        if (value.state == TaskState.success) {
          print('================= Upload Complete =================');
        }
      });
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  ///Update Method

  static Future<MenuData> updateDataMenu(String id, MenuData menuData) {
    return _menu
        .doc(id)
        .set(
          menuData.toJson(),
        )
        .then((value) {
      return getDataMenu(id);
    }).onError((error, stackTrace) {
      return Future.error(error ?? '');
    });
  }

  static Future<MenuData> updateDataMenuAndImage(
      String id, MenuData menuData, String? filePath) async {
    if (filePath != null) {
      return uploadPhotos(filePath, id).then((value) {
        return getDownloadUrl(id).then((imageIrl) {
          return updateDataMenu(
              id,
              MenuData(
                name: menuData.name,
                description: menuData.description,
                price: menuData.price,
                imageUrl: imageIrl,
              ));
        });
      });
    } else {
      return updateDataMenu(id, menuData);
    }
  }

  ///Delete Method

  static Future<String> deleteDataMenu(String id) {
    return _menu.doc(id).delete().then((value) {
      return deletePhotos(id);
    }).onError((error, stackTrace) {
      return Future.error(error ?? '');
    });
  }

  static Future<String> deletePhotos(String ref) async {
    try {
      return await firebaseStorage
          .ref('$ref/image_$ref.jpg')
          .delete()
          .then((value) {
        print('================= Delete Complete =================');
        return Future.value('Success Delete Data Menu');
      });
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
}
