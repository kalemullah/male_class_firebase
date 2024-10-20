import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/auth/sign_up/sign_up.dart';
import 'package:firebase_project/UI/firebase_firestore/show_data.dart';
import 'package:flutter/material.dart';

class SplashService {
  void islogin(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ShowData()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
      }
    });
  }
}
