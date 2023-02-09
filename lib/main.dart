// ignore_for_file: must_call_super, unused_field

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/home_page.dart';
import 'package:login/screens/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final islogin = await prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(islogin: islogin));
}

class DefaultFirebaseOptions {
  static var currentPlatform;
}

void setState(Null Function() param0) {}

class MyApp extends StatefulWidget {
  bool? islogin;
  MyApp({
    super.key,
    required this.islogin,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print(widget.islogin);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget.islogin! ? HomePage() : Loginpage(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(360, 640),
    );
  }
}
