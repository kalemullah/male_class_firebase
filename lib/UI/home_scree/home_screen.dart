import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/auth/sign_up/sign_up.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isdataadded = false;
  DatabaseReference db = FirebaseDatabase.instance.ref('todo');
  TextEditingController datacontroller = TextEditingController();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: datacontroller,
              decoration: const InputDecoration(
                  hintText: 'Enter data', border: OutlineInputBorder()),
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: CustomButton(
              isloading: isdataadded,
              text: 'add data',
              height: 50.0,
              width: 300.0,
              color: Colors.teal,
              onPressed: () {
                setState(() {
                  isdataadded = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();
                if (datacontroller.text.isEmpty) {
                  ToastPopUp()
                      .toast('please enter data', Colors.red, Colors.white);
                  setState(() {
                    isdataadded = false;
                  });
                  return;
                } else {
                  print('this is current time ${id}');
                  db.child(id).set({
                    'name': datacontroller.text.trim(),
                    'age': 30,
                    'id': id
                  }).then((v) {
                    datacontroller.clear();
                    ToastPopUp()
                        .toast('data added', Colors.green, Colors.white);
                    setState(() {
                      isdataadded = false;
                    });
                  }).onError((error, v) {
                    ToastPopUp()
                        .toast(error.toString(), Colors.red, Colors.white);
                    setState(() {
                      isdataadded = false;
                    });
                  });
                }
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: db,
                  itemBuilder: (context, snapshot, _, index) {
                    return ListTile(
                      title: Text(snapshot.child('age').key.toString()),
                      subtitle: Text(snapshot.child('name').value.toString()),
                      trailing: GestureDetector(
                          onTap: () {
                            print('${snapshot.child('id').value.toString()}');
                            db
                                .child(snapshot.child('id').value.toString())
                                .remove()
                                .then((value) {
                              print('data deleted successfully');
                              // print('$value');
                              ToastPopUp().toast(
                                  'data deleted', Colors.green, Colors.white);
                            }).onError((Error, v) {
                              ToastPopUp()
                                  .toast(Error, Colors.green, Colors.white);
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    );
                  }))
        ],
      ),
    );
  }
}
