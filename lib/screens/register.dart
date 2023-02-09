// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, avoid_print, deprecated_member_use, prefer_typing_uninitialized_variables, non_constant_identifier_names, body_might_complete_normally_nullable, unused_field, unused_element, must_call_super

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/auth_service.dart';
import 'package:login/background.dart';
import 'package:login/screens/log_in.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

  bool _passwordVisible = false;
  bool _confirmpassword = false;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmpassword = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
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
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 165.h,
                              ),
                              signUpLabel(),
                              SizedBox(
                                height: 20.h,
                              ),

                              //email

                              TextFormField(
                                cursorColor: Colors.blue,
                                controller: _emailController,
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

                              SizedBox(height: 14.h),

                              //password
                              TextFormField(
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
                                cursorColor: Colors.blue,
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 13.w, vertical: 12.h),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
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
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                ),
                              ),

                              SizedBox(height: 14.h),

                              //confirm password

                              TextFormField(
                                validator: ((value) {
                                  if (value != _passwordController.value.text) {
                                    return "Password do not match";
                                  }
                                  return null;
                                }),
                                cursorColor: Colors.blue,
                                obscureText: !_confirmpassword,
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 13.w, vertical: 12.h),
                                  hintText: 'ConfirmPassword',
                                  hintStyle: const TextStyle(
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
                                        _confirmpassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _confirmpassword = !_confirmpassword;
                                        });
                                      }),
                                ),
                              ),

                              SizedBox(
                                height: 14.h,
                              ),

                              // sign up button

                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: Colors.blue[300]),
                                  child: TextButton(
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          try {
                                            final credential = await FirebaseAuth
                                                .instance
                                                .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            )
                                                .then((value) async {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                showCloseIcon: true,
                                                desc: "Signup Successfully",
                                              ).show();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Loginpage()));
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'weak-password') {
                                              print(
                                                  'The password provided is too weak.');
                                            } else if (e.code ==
                                                'email-already-in-use') {
                                              print(
                                                  'The account already exists for that email.');
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
                                      child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.h,
                                        ),
                                      )),
                                ),
                              ),

                              SizedBox(height: 15.h),

                              //google button

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

                              //signup to login

                              SizedBox(height: 14.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: TextStyle(fontSize: 12.h),
                                  ),
                                  SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Loginpage()));
                                    },
                                    child: Text(
                                      'Login now',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 107.h),
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

  _togglePasswordView(type) {
    if (type == 0) {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }

    if (type == 1) {
      setState(() {
        _confirmpassword = !_confirmpassword;
      });
    }
  }

  signUpLabel() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Sign Up",
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
