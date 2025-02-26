import 'package:flutter/material.dart';
import 'package:mytask/screens/welcome_screen.dart';
import 'package:mytask/task_list.dart';
import 'package:mytask/task_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEE d MMM').format(DateTime.now());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: Container(
          color: Color(0xff888af5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row with grid icon, search bar, and three dots
              Padding(
                padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Row(
                  children: [
                    Icon(Icons.grid_view, color: Colors.white),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_horiz, color: Colors.white),
                      onSelected: (String value) {
                        if (value == 'logout') {
                          logout(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Sign Out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Second row with date like "Today 1 May"
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  date,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              // Third row with "My Tasks"
              Padding(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  'My Tasks',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6669f6),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm()),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.list_outlined,
                  size: 30,
                  color: Color(0xff666af4),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
