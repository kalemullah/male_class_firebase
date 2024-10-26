import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/auth/login/login.dart';
import 'package:firebase_project/UI/chat_screen/chat_screen.dart';
import 'package:firebase_project/UI/chat_screen/conversation.dart';
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
  final db = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

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
                            title: Text(snapshot.data!.docs[index]['name']),
                            subtitle: Text(snapshot.data?.docs[index]['email']),
                            trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                                recieverName: snapshot
                                                    .data!.docs[index]['name'],
                                                recieverId: snapshot
                                                    .data!.docs[index]['uid'],
                                              )));
                                },
                                child: Icon(
                                  Icons.message,
                                  color: Colors.teal,
                                )),
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              }),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Conversation()));
            },
            child: Container(
              height: 50,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text('Conversation')),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
