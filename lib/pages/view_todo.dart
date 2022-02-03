import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_auth_app/pages/home_page.dart';

class ViewTodoPage extends StatefulWidget {
  const ViewTodoPage({Key? key, required this.document, required this.id})
      : super(key: key);

  final Map<String, dynamic> document;
  final String id;

  @override
  _ViewTodoPageState createState() => _ViewTodoPageState();
}

class _ViewTodoPageState extends State<ViewTodoPage> {
  late final TextEditingController _titleController;
  late TextEditingController _descriptionController = TextEditingController();
  late String? type;
  late String category;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState

    String title = widget.document['title'] ?? 'Please Add Title';
    super.initState();
    _titleController = TextEditingController(text: title);
    _descriptionController =
        TextEditingController(text: widget.document['description']);
    type = widget.document['task'];
    category = widget.document['Category']??'';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black45,
      //   title: const Text('Add Todo'),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff1d1e26),
            Color(0xff252041),
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Todo')
                              .doc(widget.id)
                              .delete()
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => const HomePage()));

                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.green : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? 'Editing' : 'View',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Your Todo',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          letterSpacing: 2),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label('Task Title'),
                    const SizedBox(
                      height: 12,
                    ),
                    title(),
                    const SizedBox(
                      height: 30,
                    ),
                    label('Task Type'),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect('Important', Colors.blueAccent),
                        const SizedBox(
                          width: 20,
                        ),
                        taskSelect('Planned', Colors.cyan),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label('Description'),
                    const SizedBox(
                      height: 10,
                    ),
                    description(),
                    const SizedBox(
                      height: 25,
                    ),
                    label('Category'),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect('Food', Colors.amberAccent),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect('WorkOut', Colors.deepPurple),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect('Work', Colors.deepOrangeAccent),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect('Design', Colors.blueAccent),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect('Run', Colors.greenAccent),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    edit ? button() : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('Todo').doc(widget.id).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'task': type,
          'Category': category,
        });
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (builder) => const HomePage()),
        //     (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                colors: [Colors.purple, Colors.indigoAccent])),
        child: const Center(
          child: Text(
            'Update Todo',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Description',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String label, Color color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: type == label ? Colors.white : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: type == label ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categorySelect(String label, Color color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: category == label ? Colors.white : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: category == label ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Task Title',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
      ),
    );
  }
}
