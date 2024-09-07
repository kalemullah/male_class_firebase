import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/auth/sign_up/sign_up.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                auth.currentUser!.delete().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()));
                }).onError((Error, v) {
                  print(Error);
                  ToastPopUp()
                      .toast(Error.toString(), Colors.red, Colors.white);
                });
              },
              child: Icon(Icons.delete)),
          GestureDetector(
              onTap: () {
                auth.signOut().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                }).onError((Error, v) {
                  print(Error);
                  ToastPopUp()
                      .toast(Error.toString(), Colors.green, Colors.white);
                });
              },
              child: Icon(Icons.logout)),
        ],
      ),
    );
  }
}
