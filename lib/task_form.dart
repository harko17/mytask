import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskForm extends StatefulWidget {
  final String? docId;
  TaskForm({this.docId});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now();
  String priority = 'Low';

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.docId)
          .get()
          .then((doc) {
        titleController.text = doc['title'];
        descriptionController.text = doc['description'];
        dueDate = (doc['dueDate'] as Timestamp).toDate();
        priority = doc['priority'];
        setState(() {});
      });
    }
  }

  void saveTask() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if (widget.docId == null) {
      FirebaseFirestore.instance.collection('tasks').add({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'dueDate': dueDate,
        'priority': priority,
        'completed': false,
        'userId': uid
      });
    } else {
      FirebaseFirestore.instance.collection('tasks').doc(widget.docId).update({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'dueDate': dueDate,
        'priority': priority
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff888af5),
      appBar:
      AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff888af5),
          centerTitle: true,
          title: Text(widget.docId == null ? 'Add Task' : 'Edit Task',style: TextStyle(color: Colors.white,),)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title')),
                  SizedBox(height: 16),
                  TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description')),
                  SizedBox(height: 16),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Due Date: ${dueDate.toLocal()}'.split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (picked != null) setState(() => dueDate = picked);
                      }),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Priority', style: TextStyle(fontSize: 16)),
                  ),
                  DropdownButtonFormField(
                      value: priority,
                      items: ['Low', 'Medium', 'High']
                          .map((value) => DropdownMenuItem(
                          value: value, child: Text(value)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => priority = value as String),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10))),
                  SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: saveTask,
                      child: Text('Save Task',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFF6669f6),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
