import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuInteractor {
  static Future<List<MenuData>> getMenuList() async {
    return MenuViewModel.getMenuList(false);
  }

  static Future<int> getMenuCount()async{
    return MenuViewModel.getMenuCount();
  }

  static Future<MenuData> insertNewMenu(
      MenuData menuData, String filePath) async {
    return MenuViewModel.insertNewMenu(menuData, filePath);
  }

  static Future<MenuData> updateMenu(
      String menuId, MenuData menuData, String? filePath) async {
    return MenuViewModel.updateDataMenuAndImage(menuId, menuData, filePath);
  }

  static Future<String> deleteMenu(String menuId) async {
    return MenuViewModel.deleteDataMenu(menuId);
  }
}
