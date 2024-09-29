import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/auth/sign_up/sign_up.dart';
import 'package:firebase_project/UI/home_scree/home2_screen.dart';
import 'package:firebase_project/UI/home_scree/profile_screen.dart';
import 'package:firebase_project/UI/home_scree/update_screen.dart';
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
  late Query query;
  DatabaseReference db = FirebaseDatabase.instance.ref('todo');

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descrcontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();

  @override
  void initState() {
    query = db.orderByChild('uid').equalTo(auth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              child: Icon(Icons.person)),
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
              controller: titlecontroller,
              decoration: const InputDecoration(
                  hintText: 'title', border: OutlineInputBorder()),
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              maxLines: 3,
              controller: descrcontroller,
              decoration: const InputDecoration(
                  hintText: 'Description', border: OutlineInputBorder()),
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
                if (titlecontroller.text.isEmpty &&
                    descrcontroller.text.isEmpty) {
                  ToastPopUp()
                      .toast('please enter data', Colors.red, Colors.white);
                  setState(() {
                    isdataadded = false;
                  });
                  return;
                } else {
                  print('this is current time ${id}');
                  db.child(id).set({
                    'uid': auth.currentUser!.uid,
                    'title': titlecontroller.text.trim(),
                    'description': descrcontroller.text.trim(),
                    'id': id
                  }).then((v) {
                    titlecontroller.clear();
                    descrcontroller.clear();
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
          SizedBox(
            height: 5,
          ),
          CustomButton(
            height: 40.0,
            width: 100.0,
            color: Colors.teal,
            text: 'Home2',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen2()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              controller: searchcontroller,
              decoration: InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() {});
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: query,
                  itemBuilder: (context, snapshot, _, index) {
                    if (snapshot
                        .child('title')
                        .value
                        .toString()
                        .contains(searchcontroller.text.toString())) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateScreen(
                                  title:
                                      snapshot.child('title').value.toString(),
                                  desc: snapshot
                                      .child('description')
                                      .value
                                      .toString(),
                                  id: snapshot.child('id').value.toString(),
                                ),
                              ));
                        },
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                            snapshot.child('description').value.toString()),
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
                    } else if (searchcontroller.text.isEmpty) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateScreen(
                                  title:
                                      snapshot.child('title').value.toString(),
                                  desc: snapshot
                                      .child('description')
                                      .value
                                      .toString(),
                                  id: snapshot.child('id').value.toString(),
                                ),
                              ));
                        },
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                            snapshot.child('description').value.toString()),
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
                    } else {
                      return Container();
                    }
                  }))
        ],
      ),
    );
  }
}
