import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.recieverId, required this.recieverName});
  final String recieverId;
  final String recieverName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String combineId(senderid, recieverid) {
    // String combineId = senderid + "-" + recieverid;
    List<String> ids = [senderid, recieverid];

    ids.sort();

    String joinid = ids.join("_");
    return joinid;
  }

  sendMessage() {
    String combineid =
        combineId(FirebaseAuth.instance.currentUser!.uid, widget.recieverId);
    print(' recieverId ${widget.recieverId}');
    print('senderid ${FirebaseAuth.instance.currentUser!.uid}');
    print('send');
    print('this is controller value ${messageController.text}');

    FirebaseFirestore.instance.collection('messages').doc(combineid).set({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'recieverId': widget.recieverId,
      'lastmessage': messageController.text,
      'combinedId': combineid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    String chatid = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(combineid)
        .collection('chat')
        .doc(chatid)
        .set({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'message': messageController.text,
      'chatid': chatid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((v) {
      print('message sent');
      messageController.clear();
    }).onError((error, stackTrace) {
      print('error sending message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(widget.recieverName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(combineId(FirebaseAuth.instance.currentUser!.uid,
                        widget.recieverId))
                    .collection('chat')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return BubbleSpecialThree(
                          text: '${snapshot.data!.docs[index]['message']}',
                          color: snapshot.data!.docs[index]['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Colors.grey.withOpacity(.8)
                              : Color(0xFF1B97F3),
                          isSender: snapshot.data!.docs[index]['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? true
                              : false,
                          tail: true,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        );
                      });
                }),
          ),
          Container(
            height: 50,
            // width: 200,
            decoration: BoxDecoration(color: Colors.grey[200]),

            child: Row(
              children: [
                Container(
                    height: 50,
                    width: 330,
                    child: TextField(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      controller: messageController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Type a message',
                          border: InputBorder.none),
                    )),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                    onPressed: () => sendMessage(), icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
