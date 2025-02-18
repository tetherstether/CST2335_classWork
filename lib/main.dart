import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final EncryptedSharedPreferences encryptedPrefs = EncryptedSharedPreferences();
  runApp(MyApp(encryptedPrefs: encryptedPrefs));
}

class MyApp extends StatelessWidget {
  final EncryptedSharedPreferences encryptedPrefs;
  const MyApp({super.key, required this.encryptedPrefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5 Flutter App',
      home: LoginPage(encryptedPrefs: encryptedPrefs),
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final savedLogin = await widget.encryptedPrefs.getString('login');
    final savedPassword = await widget.encryptedPrefs.getString('password');
    if (savedLogin != null && savedPassword != null) {
      _loginController.text = savedLogin;
      _passwordController.text = savedPassword;
    }
  }

  void _login() {
    if (_passwordController.text == "QWERTY123") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            loginName: _loginController.text,
            encryptedPrefs: widget.encryptedPrefs,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _loginController, decoration: InputDecoration(labelText: "Login name")),
            SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String loginName;
  final EncryptedSharedPreferences encryptedPrefs;
  const ProfilePage({super.key, required this.loginName, required this.encryptedPrefs});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back, ${widget.loginName}")),
      );
    });
  }

  void _loadData() async {
    _firstNameController.text = await widget.encryptedPrefs.getString('firstName') ?? '';
    _lastNameController.text = await widget.encryptedPrefs.getString('lastName') ?? '';
    _phoneController.text = await widget.encryptedPrefs.getString('phone') ?? '';
    _emailController.text = await widget.encryptedPrefs.getString('email') ?? '';
  }

  void _saveData() async {
    await widget.encryptedPrefs.setString('firstName', _firstNameController.text);
    await widget.encryptedPrefs.setString('lastName', _lastNameController.text);
    await widget.encryptedPrefs.setString('phone', _phoneController.text);
    await widget.encryptedPrefs.setString('email', _emailController.text);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text("Error"), content: Text("Cannot open $url"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome Back, ${widget.loginName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: _lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            Row(children: [
              Flexible(child: TextField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone Number"))),
              IconButton(icon: Icon(Icons.phone), onPressed: () => _launchURL("tel:${_phoneController.text}")),
              IconButton(icon: Icon(Icons.message), onPressed: () => _launchURL("sms:${_phoneController.text}")),
            ]),
            Row(children: [
              Flexible(child: TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email Address"))),
              IconButton(icon: Icon(Icons.mail), onPressed: () => _launchURL("mailto:${_emailController.text}")),
            ]),
            ElevatedButton(onPressed: _saveData, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
