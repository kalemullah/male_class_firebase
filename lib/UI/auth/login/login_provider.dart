import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/firebase_firestore/show_data.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool istrue = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = false;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  void login(context) {
    isloading = true;
    notifyListeners();
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passwordController.text.toString().trim())
        .then((v) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ShowData()));

      isloading = false;
      notifyListeners();
      ToastPopUp().toast('Sign In successful', Colors.green, Colors.white);
    }).onError((Error, v) {
      ToastPopUp().toast(Error.toString(), Colors.red, Colors.white);
      isloading = false;
      notifyListeners();
    });
  }
}
