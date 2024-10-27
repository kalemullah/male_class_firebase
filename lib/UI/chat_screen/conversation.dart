import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'conversation',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var chatlist = snapshot.data!.docs.where((element) {
                    String combinid = element['combinedId'];
                    return combinid
                        .contains(FirebaseAuth.instance.currentUser!.uid);
                  }).toList();

                  print('this is all data ${chatlist.length}');

                  return Expanded(
                    child: ListView.builder(
                        itemCount: chatlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            recieverId: FirebaseAuth.instance
                                                        .currentUser!.uid ==
                                                    chatlist[index]
                                                        ['recieverId']
                                                ? chatlist[index]['senderId']
                                                : chatlist[index]['recieverId'],
                                            recieverName: FirebaseAuth.instance
                                                        .currentUser!.uid ==
                                                    chatlist[index]
                                                        ['recieverId']
                                                ? chatlist[index]['sendername']
                                                : chatlist[index]
                                                    ['recievername'],
                                          )));
                            },
                            title: FirebaseAuth.instance.currentUser!.uid ==
                                    chatlist[index]['recieverId']
                                ? Text(chatlist[index]['sendername'])
                                : Text(chatlist[index]['recievername']),
                            subtitle: Text(chatlist[index]['lastmessage']),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
