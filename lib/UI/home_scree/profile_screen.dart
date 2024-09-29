import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  DatabaseReference db = FirebaseDatabase.instance.ref('Users');
  void getData() async {
    var snap = await db.child(FirebaseAuth.instance.currentUser!.uid).get();
    if (snap.exists) {
      setState(() {
        name = snap.child('name').value.toString();
        email = snap.child('email').value.toString();
      });
      print(snap.child('name').value);
      print(snap.child('email').value);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              email,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
