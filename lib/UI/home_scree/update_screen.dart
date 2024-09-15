import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:firebase_project/utils/tost_popup.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen(
      {super.key, required this.title, required this.desc, required this.id});
  final title;
  final desc;
  final id;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  DatabaseReference db = FirebaseDatabase.instance.ref('todo');
  TextEditingController updatetitlecontroller = TextEditingController();
  TextEditingController updatedescriptionecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    updatetitlecontroller.text = widget.title.toString();
    updatedescriptionecontroller.text = widget.desc.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextField(
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
              controller: updatetitlecontroller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
              controller: updatedescriptionecontroller,
              decoration: const InputDecoration(
                  hintText: 'desc', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            CustomButton(
              text: 'update',
              onPressed: () {
                db.child(widget.id).update({
                  'title': updatetitlecontroller.text.trim(),
                  'description': updatedescriptionecontroller.text.trim()
                }).then((value) {
                  ToastPopUp().toast('updated', Colors.green, Colors.white);
                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  ToastPopUp()
                      .toast(error.toString(), Colors.red, Colors.white);
                });
                print('this is id ${widget.id}');
                print(
                    '${updatetitlecontroller.text} ${updatedescriptionecontroller.text}');
              },
              height: 50.0,
              color: Colors.teal,
            )
          ],
        ),
      ),
    );
  }
}
