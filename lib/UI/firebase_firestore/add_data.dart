import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController titlecontroller = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController descrcontroller = TextEditingController();
  bool isdataadded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Add Data'),
        centerTitle: true,
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
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  db.collection('todo').doc(id).set({
                    "title": titlecontroller.text.toString().trim(),
                    'description': descrcontroller.text.toString().trim(),
                    'id': id,
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
        ],
      ),
    );
  }
}
