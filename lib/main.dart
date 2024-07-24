// import 'package:dictionary_app/Translate.dart';
import 'package:dictionary_app/db_helper.dart';
import 'package:dictionary_app/mydata.dart';
import 'package:dictionary_app/theme/ThemeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Splashscreen.dart';
import 'MyHomePage.dart';

void main() async {
  Get.put(Mydata());
  Get.put(ThemeController());
  DBHelper helper = DBHelper();
  Get.find<Mydata>().listdata.value =
      await helper.select("SELECT * FROM Items LIMIT 200");
  Get.find<Mydata>().favlist.value =
      await helper.select("SELECT * FROM Items WHERE fav = 1");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ThemeController themeController = Get.find(); 
        
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dictionary Application',
          theme: themeController.lightTheme,
          darkTheme: themeController.darkTheme,
          themeMode:
              themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => SplashScreen()),
            GetPage(name: '/home', page: () => MyHomePage()),
          ],
        ));
  }
}
