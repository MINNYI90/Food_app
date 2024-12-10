import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_final_food_update/tab_menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _nameController = TextEditingController();
  // final _statusController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('https://apifood-gules.vercel.app/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text,
    });

    final res = await http.post(url, headers: headers, body: body);
    final jsonRes = jsonDecode(res.body);

    if (res.statusCode == 200) {
      // Navigate to TabeMenuPage, passing fname and lname
      _showSnackBar(jsonRes['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabeMenuPage(
            username: jsonRes['user']['username'],
            password: jsonRes['user']['password'],
            name: jsonRes['user']['name'], // Pass fname
            status: jsonRes['user']['status'],
            avatar: jsonRes['user']['avatar'] ??
                'https://via.placeholder.com/150', // Pass lname
          ),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://cdn.vectorstock.com/i/1000v/43/65/food-delivery-vector-4904365.jpg',
                  width: 150,
                  height: 150,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
