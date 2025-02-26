import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:mytask/screens/register_page.dart';
import 'package:mytask/screens/task_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isEmailValid = false;

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TaskPage()));

    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('Invalid credentials')));
    }
  }

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
    } catch (e) {}
  }

  void validateEmail(String value) {
    setState(() {
      isEmailValid = value.endsWith('@gg.in');
    });
  }

  void showPassword() {
    setState(() {
      obscurePassword = false;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        obscurePassword = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 60),
            Center(child: Image.asset('assets/logo.png', height: 150)),
            SizedBox(height: 20),
            Text(
              'Welcome back',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email Address',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              onChanged: validateEmail,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                suffixIcon: isEmailValid
                    ? Icon(
                  Icons.check,
                  color: Colors.grey,
                )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: showPassword,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: login,
              child: Text(
                'Log In',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6669f6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 42),
            Text('or log in with'),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue[800],
                    child: IconButton(
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: Icon(
                        Icons.g_mobiledata,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: Icon(
                        Icons.apple,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Get started!',
                      style: TextStyle(
                          color: Color(0xFF6669f6), fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
