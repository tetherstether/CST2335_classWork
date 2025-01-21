import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 Flutter App',
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Controllers to handle text input
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable to store the image path
  String imageSource = "images/question-mark.png"; // Default image

  // Function to handle login logic
  void _login() {
    String password =
        _passwordController.text; // Get password entered by the user

    setState(() {
      if (password == "QWERTY123") {
        // Change to light bulb image if the password is correct
        imageSource = "images/idea.png";
      } else {
        // Change to stop sign image if the password is incorrect
        imageSource = "images/stop.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login name text field
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: "Login name",
              ),
            ),
            SizedBox(height: 16),

            // Password text field with obscure text
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide the password
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            SizedBox(height: 16),

            // Elevated button to trigger login
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            SizedBox(height: 16),

            // Display the image based on password validity
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}