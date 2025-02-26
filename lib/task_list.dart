import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytask/task_tile.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final filterProvider = StateProvider<Map<String, String>>(
        (ref) => {'priority': 'All', 'status': 'All'});

class TaskList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filters = ref.watch(filterProvider);
    return Column(children: [
      FilterBar(),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: getTasksStream(filters),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(child: Text('Error loading tasks'));
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            var docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Center(child: Text('No Task'));
            }

            var groupedTasks = groupTasks(docs);
            return ListView(
              children: groupedTasks.entries.map((entry) {
                return TaskGroup(date: entry.key, tasks: entry.value);
              }).toList(),
            );
          },
        ),
      ),
    ]);
  }

  Stream<QuerySnapshot> getTasksStream(Map<String, String> filters) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    Query query = FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('dueDate');
    if (filters['priority'] != 'All')
      query = query.where('priority', isEqualTo: filters['priority']);
    if (filters['status'] != 'All')
      query =
          query.where('completed', isEqualTo: filters['status'] == 'Completed');
    return query.snapshots();
  }

  Map<String, List<QueryDocumentSnapshot>> groupTasks(
      List<QueryDocumentSnapshot> docs) {
    Map<String, List<QueryDocumentSnapshot>> groups = {};
    var today = DateTime.now();
    var tomorrow = today.add(Duration(days: 1));
    var weekEnd = today.add(Duration(days: 7 - today.weekday));
    for (var doc in docs) {
      DateTime dueDate = (doc['dueDate'] as Timestamp).toDate();
      String group;
      if (isSameDay(dueDate, today))
        group = 'Today';
      else if (isSameDay(dueDate, tomorrow))
        group = 'Tomorrow';
      else if (dueDate.isBefore(weekEnd))
        group = 'This Week';
      else
        group = DateFormat.yMMMd().format(dueDate);
      if (!groups.containsKey(group)) groups[group] = [];
      groups[group]!.add(doc);
    }
    return groups;
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

class FilterBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filters = ref.watch(filterProvider);
    return Container(
      color: Colors.white54,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(Icons.filter_alt_outlined),
        DropdownButton(
            value: filters['priority'],
            items: ['All', 'Low', 'Medium', 'High']
                .map((value) =>
                DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) {
              var newFilters = Map<String, String>.from(filters);
              newFilters['priority'] = value as String;
              ref.read(filterProvider.notifier).state = newFilters;
            }),
        DropdownButton(
            value: filters['status'],
            items: ['All', 'Completed', 'Incomplete']
                .map((value) =>
                DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) {
              var newFilters = Map<String, String>.from(filters);
              newFilters['status'] = value as String;
              ref.read(filterProvider.notifier).state = newFilters;
            })
      ]),
    );
  }
}

class TaskGroup extends StatelessWidget {
  final String date;
  final List<QueryDocumentSnapshot> tasks;
  TaskGroup({required this.date, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(date, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          ),
          ...tasks.map((doc) => TaskTile(taskDoc: doc)).toList(),
        ],
      ),
    );
  }
}
