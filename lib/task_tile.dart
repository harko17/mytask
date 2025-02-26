import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytask/task_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final QueryDocumentSnapshot taskDoc;
  TaskTile({required this.taskDoc});

  void toggleComplete() {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskDoc.id)
        .update({'completed': !taskDoc['completed']});
  }

  void deleteTask(BuildContext context) {
    FirebaseFirestore.instance.collection('tasks').doc(taskDoc.id).delete();
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: DrawerMotion(), children: [
        SlidableAction(
          onPressed: (_) => deleteTask(context),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: Colors.white,
          child: ListTile(
            leading: GestureDetector(
              onTap: toggleComplete,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: taskDoc['completed'] ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                ),
                child: taskDoc['completed']
                    ? Icon(Icons.check, size: 16, color: Colors.blue)
                    : null,
              ),
            ),
            title: Text(taskDoc['description']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due: ${(taskDoc['dueDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        taskDoc['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: getPriorityColor(taskDoc['priority']),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        taskDoc['priority'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskForm(docId: taskDoc.id)),
            ),
          ),
        ),
      ),
    );
  }
}
