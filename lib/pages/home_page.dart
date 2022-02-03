import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_auth_app/pages/add_todo_page.dart';
import 'package:todo_auth_app/pages/todo_card.dart';
import 'package:todo_auth_app/pages/view_todo.dart';
import 'package:todo_auth_app/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Todo').snapshots();

  List<Select> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Today\'s Schedule',
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/profile.jpeg'),
          ),
          SizedBox(
            height: 25,
          ),
        ],
        bottom:  PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    'Monday 21',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  // IconButton(
                  // //   icon: const Icon(
                  // //     Icons.delete,
                  // //     color: Colors.white,
                  // //   ),
                  // //   onPressed: () {
                  // //     // var instance = FirebaseFirestore.instance
                  // //     //     .collection('Todo');
                  // //     // for ( int i =0 ; i <selected.length; i ++){
                  // //     //   instance.doc();
                  // //     // }
                  // //
                  // //   },
                  // // ),
                ],
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            // ignore: deprecated_member_use
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddTodoPage()));
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 38,
                  color: Colors.white,
                ),
              ),
            ),
            // ignore: deprecated_member_use
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            // ignore: deprecated_member_use
            title: Container(),
          ),
        ],
      ),
      body: StreamBuilder<dynamic>(
          stream: _stream,
          builder: (BuildContext context, snapshot) {
            // ignore: unused_local_variable
            // QuerySnapshot doc = snapshot.data as QuerySnapshot;
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                IconData iconData;
                Color iconColor;
                Map<String, dynamic> document =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;

                switch (document['Category']) {
                  case 'Work':
                    iconData = Icons.work_outlined;
                    iconColor = Colors.cyanAccent;
                    break;
                  case 'Workout':
                    iconData = Icons.fitness_center_outlined;
                    iconColor = Colors.tealAccent;
                    break;
                  case 'Food':
                    iconData = Icons.local_grocery_store;
                    iconColor = Colors.amber;
                    break;
                  case 'Run':
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.blue;
                    break;
                  case 'Design':
                    iconData = Icons.design_services_outlined;
                    iconColor = Colors.purple;
                    break;
                  default:
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                }
                selected.add(
                  Select(id: snapshot.data.docs[index].id, checkValue: false),
                );

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ViewTodoPage(
                            document: document,
                            id: snapshot.data.docs[index].id,
                          ),
                        ));

                  },
                  child: TodoCard(
                    title: document['title'] ?? 'Please Add Title',
                    check: selected[index].checkValue,
                    iconBGColor: Colors.white,
                    iconColor: iconColor,
                    iconData: iconData,
                    time: '10 AM',
                    onChange: onChange,
                    index: index,
                  ),
                );
              },
            );
          }),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}

// IconButton(
// onPressed: () async {
// await authClass.logout();
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(builder: (builder) => const SignUpPage()),
// (route) => false);
// },
// icon: const Icon(
// Icons.logout,
// ),
// ),
