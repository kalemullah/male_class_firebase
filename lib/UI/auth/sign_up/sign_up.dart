import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Sign Up',
                  height: 50.h,
                  width: 200.w,
                  isloading: isloading,
                  color: Colors.teal,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });
                      auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString().trim(),
                              password:
                                  passwordController.text.toString().trim())
                          .then((v) {
                        setState(() {
                          isloading = false;
                        });
                      }).onError((Error, v) {
                        Fluttertoast.showToast(
                            msg: Error.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          isloading = false;
                        });
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
