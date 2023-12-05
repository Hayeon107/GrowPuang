import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growpuang/view/login/LoginPage.dart';
import 'package:growpuang/view/mbti/firstPage.dart';
import 'package:growpuang/view/widget/appBar_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widget/end_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _usernameController = new TextEditingController();
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool saving = false;
  String email = '';
  String password = '';
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: saving,
      child: Scaffold(
        appBar: null,
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children:[ Container(
            width: double.infinity,
            // height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/로그인화면.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20.w, 380.h, 20.w, 130.h),
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
              color: Colors.white.withOpacity(0.5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogInPage()));
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Color(0xFFB7B7B7),
                              fontFamily: 'YourFontFamily',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Color(0xFF314C07),
                              fontFamily: 'YourFontFamily',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: _emailController,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "email",
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "password",
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      onChanged: (value) {
                        userName = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "UserName",
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: 500.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              saving = true;
                            });

                            // Check if the email already exists
                            bool emailExists = await isEmailExists(email);

                            if (emailExists) {
                              // Email already exists, show alert dialog
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text("회원가입 실패\nSign-up failed"),
                                    content: const Text(
                                        "이미 등록된 이메일입니다.\nThis email is already registered"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            saving = !emailExists;
                                          });
                                        },
                                        child: Text("확인"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Email doesn't exist, proceed with registration
                              final newUser = await _authentication
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'userName': userName,
                                'email': email,
                              });
                              if (newUser.user != null) {
                                _formKey.currentState!.reset();
                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LogInPage()));
                                setState(() {
                                  saving = false;
                                });
                              }
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF99C958),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          elevation: 3,
                          shadowColor: Colors.black,
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: const Color(0xFF314C07),
                            fontFamily: 'YourFontFamily',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),]
        ),
      ),
    );
  }

  Future<bool> isEmailExists(String email) async {
    // Check if the email already exists in Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<Future> showExitPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return EndDialog();
      },
    );
  }
}
