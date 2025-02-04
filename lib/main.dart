import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  final EncryptedSharedPreferences encryptedPrefs = EncryptedSharedPreferences();
  runApp(MyApp(encryptedPrefs: encryptedPrefs)); // Pass EncryptedSharedPreferences to MyApp
}

class MyApp extends StatelessWidget {
  final EncryptedSharedPreferences encryptedPrefs;
  const MyApp({super.key, required this.encryptedPrefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 Flutter App',
      home: LoginPage(encryptedPrefs: encryptedPrefs), // Pass EncryptedSharedPreferences to LoginPage
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final EncryptedSharedPreferences encryptedPrefs;
  const LoginPage({super.key, required this.encryptedPrefs});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Controllers to handle text input
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable to store the image path
  String imageSource = "images/question-mark.png"; // Default image

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Function to load saved credentials
  void _loadSavedCredentials() async {
    final savedLogin = await widget.encryptedPrefs.getString('login');
    final savedPassword = await widget.encryptedPrefs.getString('password');

    // Check if the saved values are not null
    if (savedLogin != null && savedPassword != null) {
      _loginController.text = savedLogin;
      _passwordController.text = savedPassword;

      // Show SnackBar with Undo option only if credentials are loaded
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Previous login credentials loaded.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _loginController.text = '';
                  _passwordController.text = '';
                });
              },
            ),
          ),
        );
      }
    }
  }

  // Function to handle login logic
  void _login() {
    String password = _passwordController.text;

    setState(() {
      if (password == "QWERTY123") {
        imageSource = "images/idea.png";
      } else {
        imageSource = "images/stop.png";
      }
    });

    // Show AlertDialog to ask if the user wants to save credentials
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Credentials?'),
          content: Text('Do you want to save your login name and password?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(false); // Do not save credentials
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(true); // Save credentials
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _saveCredentials(bool save) async {
    if (save) {
      await widget.encryptedPrefs.setString('login', _loginController.text);
      await widget.encryptedPrefs.setString('password', _passwordController.text);
    } else {
      // Set the saved credentials to empty strings to clear them
      await widget.encryptedPrefs.clear();
    }
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
              obscureText: true,
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