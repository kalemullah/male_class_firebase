import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/firebase_firestore/add_data.dart';
import 'package:firebase_project/UI/firebase_firestore/profile_screen.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('todo').snapshots();
  final ref = FirebaseFirestore.instance
      .collection('todo')
      .where('age', isGreaterThan: 20)
      .get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Data'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen2()));
              },
              child: Icon(Icons.person)),
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
              child: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddData()));
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: db,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('error');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            // leading: GestureDetector(
                            //     onTap: () {
                            //       // snapshot.data!.docs[index].reference.update({
                            //       //   'title': "test title",
                            //       //   "description": "updated data"
                            //       // });
                            //       FirebaseFirestore.instance
                            //           .collection('todo')
                            //           .doc(snapshot.data!.docs[index]['id'])
                            //           .update({
                            //         'title': "this is for testing only"
                            //       });
                            //     },
                            //     child: Icon(Icons.update)),

                            leading: Image.network(
                                snapshot.data!.docs[index]['image']),
                            title: Text(snapshot.data!.docs[index]['title']),
                            subtitle:
                                Text(snapshot.data?.docs[index]['description']),
                            trailing: GestureDetector(
                                onTap: () {
                                  snapshot.data!.docs[index].reference.delete();
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc('1')
                                      .delete();
                                },
                                child: Icon(Icons.delete)),
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              }),
          FutureBuilder(
            future: ref,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          leading: Image.network(
                              snapshot.data!.docs[index]['image']),
                          title: Text(snapshot.data!.docs[index]['title']),
                          subtitle:
                              Text(snapshot.data!.docs[index]['description']),
                        );
                      }),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}
