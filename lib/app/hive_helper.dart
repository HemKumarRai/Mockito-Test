import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
class HiveHelper {
  HiveHelper._();

  static const myHiveBoxName = "myHiveBoxName";
  static const dashBoardData = "dashBoardData";
  static final hiveBox = Hive.box(myHiveBoxName);

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox(myHiveBoxName);
  }

  static void updateMap(String key, Map<String, dynamic> value) async {
    try {
      hiveBox.put(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static T? getDatWithKey<T>(String key) {
    try{
      return hiveBox.get(key,defaultValue: null);
    }catch(e){
      return null;
    }
  }

  static Future<void> removeKeyData(String key)async{
    try{
    await  hiveBox.delete(key);
    }
    catch (e){
      debugPrint(e.toString());
    }
  }
}
