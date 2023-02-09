// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, avoid_print, deprecated_member_use, body_might_complete_normally_nullable, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, unused_element, must_call_super

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/auth_service.dart';
import 'package:login/background.dart';
import 'package:login/forget_page.dart';
import 'package:login/home_page.dart';
import 'package:login/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
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
                          key: _formfield,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 170.h,
                              ),
                              loginLabel(),

                              SizedBox(
                                height: 20.h,
                              ),

                              //email

                              Container(
                                child: TextFormField(
                                    cursorColor: Colors.blue,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        // borderSide: BorderSide(color: Colors.white70, width: 0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 13.w, vertical: 12.h),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        color: Color(0xffc5d2e1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: emailValidator),
                              ),

                              SizedBox(
                                height: 14.h,
                              ),
                              //password

                              Container(
                                child: TextFormField(
                                  cursorColor: Colors.blue,
                                  controller: _passwordController,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.r),
                                      // borderSide: BorderSide(color: Colors.white70, width: 0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 13.w, vertical: 12.h),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Color(0xffc5d2e1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.security,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: InkWell(
                                        child: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        }),
                                  ),
                                  validator: ((value) {
                                    bool passwordValid = RegExp(
                                            r"^[a-zA-z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-z0-9]+\.[a-zA-Z0-9]+")
                                        .hasMatch(value!);
                                    if (value.isEmpty) {
                                      return "Enter Passsword";
                                    } else if (value.length < 8) {
                                      return 'Pass must be at least 8 Characters.';
                                    }
                                  }),
                                ),
                              ),

                              SizedBox(height: 10.h),

                              // forgot password?

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassword()));
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.h),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              // login button

                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: Colors.blue[300]),
                                  child: TextButton(
                                      onPressed: () async {
                                        if (_formfield.currentState!
                                            .validate()) {
                                          try {
                                            final credential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            )
                                                    .then((value) async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setBool(
                                                  'isLoggedIn', true);
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                showCloseIcon: true,
                                                desc: "Login Successfully",
                                              ).show();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()));
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'user-not-found') {
                                              print(
                                                  'No user found for that email.');
                                            } else if (e.code ==
                                                'wrong-password') {
                                              print(
                                                  'Wrong password provided for that user.');
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        "LogIn",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.h,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),

                              //google

                              SizedBox(
                                width: double.infinity,
                                height: 60.h,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[300],
                                            onPrimary: Colors.white,
                                          ),
                                          icon: FaIcon(FontAwesomeIcons.google),
                                          label: Text(
                                            'Google',
                                            style: TextStyle(fontSize: 13.h),
                                          ),
                                          onPressed: (() => AuthService()
                                              .signInwithGoogle(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //login to signup

                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Not a member?',
                                    style: TextStyle(fontSize: 12.h),
                                  ),
                                  SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()));
                                    },
                                    child: Text(
                                      'Register now',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 133.h,
                              )
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

  Widget loginLabel() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Log In",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 30.sp,
        ),
      ),
    ]);
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
