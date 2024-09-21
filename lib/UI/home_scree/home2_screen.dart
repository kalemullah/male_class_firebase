import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isdataadded = false;
  DatabaseReference db = FirebaseDatabase.instance.ref('todo');
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descrcontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home2'),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
              child: StreamBuilder(
                  stream: db.onValue,
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData) {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list = map.values.toList();

                      return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('${list[index]['title']}'),
                              subtitle: Text('${list[index]['description']}'),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('something went wrong');
                    } else {
                      return Container();
                    }
                  }))
        ],
      ),
    );
  }
}
