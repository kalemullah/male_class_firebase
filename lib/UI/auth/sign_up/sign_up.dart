///
///1. adb usb
// 2. adb tcpip 5555
// 3. adb connect 192.168.10.1:5555
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/firebase_firestore/show_data.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference db = FirebaseDatabase.instance.ref('Users');
  final  ref = FirebaseFirestore.instance.collection('users');
  TextEditingController passwordController = TextEditingController();

  void signup() {
    setState(() {
      isloading = true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passwordController.text.toString().trim())
        .then((v) {
      ref.doc(v.user!.uid).set({
        'email': emailController.text.toString().trim(),
        'name': nameController.text.toString().trim(),
        'uid': v.user!.uid,
      });
      ToastPopUp().toast('Sign Up successful', Colors.green, Colors.white);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ShowData()));

      setState(() {
        isloading = false;
      });
      emailController.clear();
      passwordController.clear();
    }).onError((Error, v) {
      ToastPopUp().toast(Error.toString(), Colors.red, Colors.white);
      setState(() {
        isloading = false;
      });
    });
  }

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
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),
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
                      signup();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Sign In',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
