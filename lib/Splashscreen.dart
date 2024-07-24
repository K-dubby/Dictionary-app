import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 1), () {});
    final storage = GetStorage();
    final isFirstOpen = storage.read('isFirstOpen') ?? true;

    if (isFirstOpen) {
      storage.write('isFirstOpen', false);
      Get.offNamed('/welcome');
    } else {
      Get.offNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/book.png', width: 100)),
          SizedBox(height: 10),
          Center(
            child: Text(
              'វចនានុក្រមខ្មែរ',
              style: TextStyle(
                fontFamily: 'KhmerOSMoul',
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
