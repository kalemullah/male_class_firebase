import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/UI/firebase_firestore/add_data.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  final db = FirebaseFirestore.instance.collection('todo').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            leading: GestureDetector(
                                onTap: () {
                                  // snapshot.data!.docs[index].reference.update({
                                  //   'title': "test title",
                                  //   "description": "updated data"
                                  // });
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc(snapshot.data!.docs[index]['id'])
                                      .update({
                                    'title': "this is for testing only"
                                  });
                                },
                                child: Icon(Icons.update)),
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
              })
        ],
      ),
    );
  }
}
