import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[300],
          title: Text(
            "HomePage",
            style: TextStyle(fontSize: 24, color: Colors.black),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Text(
                "LogIn as: " + user.email!,
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                  child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                  onPrimary: Colors.white,
                ),
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text(
                  'Logout',
                  style: TextStyle(fontSize: 13.h),
                ),
                onPressed: () async {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      showCloseIcon: true,
                      desc: "Logout",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('isLoggedIn');
                        AuthService().signOutFromGoogle(context);
                      }).show();
                  await Future.delayed(const Duration(seconds: 10));
                  AuthService().signOutFromGoogle(context);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
