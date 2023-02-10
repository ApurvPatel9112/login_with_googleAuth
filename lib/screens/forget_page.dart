// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, unused_field, unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/screens/log_in.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController forgetPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    forgetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login_bk.png"),
                      fit: BoxFit.fill)),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 220),

                              // title

                              Text(
                                'Forgot Password',
                                style: TextStyle(
                                    fontSize: 20.h,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),

                              // email

                              TextFormField(
                                cursorColor: Colors.blue,
                                controller: forgetPasswordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 13.w, vertical: 12.h),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Color(0xffc5d2e1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: emailValidator,
                              ),

                              SizedBox(height: 20),

                              // update button

                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: Colors.blue[300]),
                                  child: TextButton(
                                      onPressed: () async {
                                        _formkey.currentState!.validate();

                                        var forgotEmail =
                                            forgetPasswordController.text
                                                .trim();
                                        try {
                                          await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: forgotEmail)
                                              .then((value) => {
                                                    print("Email Sent!"),
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Loginpage()))
                                                  });
                                        } on FirebaseAuthException catch (e) {
                                          print("Error $e");
                                        }
                                      },
                                      child: Text(
                                        "Reset Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )),
                                ),
                              ),

                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Remember Password?',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      } else {
                                        SystemNavigator.pop();
                                      }
                                    },
                                    child: Text(
                                      'Login ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 318,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value!.isEmpty) {
      return 'Please this field must be filled';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }
}

class Get {
  static off(Loginpage Function() param0) {}
}
