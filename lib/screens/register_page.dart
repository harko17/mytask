import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:mytask/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isEmailValid = false;

  void register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.pop(context);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('Registration failed')));
    }
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
              "Let's get started!",
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35)),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: showPassword,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: register,
              child: Text(
                'Sign Up',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6669f6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(height: 42),
            Text('or sign up with'),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              },
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'Log in',
                        style: TextStyle(color:
                            Color(0xFF6669f6), fontWeight: FontWeight.bold))
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
