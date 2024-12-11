import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_final_food_update/tab_menu_page.dart';
import 'register.dart';
// import 'forget.dart';

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

  Future<void> _register() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateUserScreen()),
    );
  }

  // Future<void> _forget() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
  //   );
  // }

  Future<void> _login() async {
    final url = Uri.parse('https://api-11-12.vercel.app/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text,
    });

    try {
      final res = await http.post(url, headers: headers, body: body);
      final jsonRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        _showSnackBar(jsonRes['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabeMenuPage(
              username: jsonRes['user']['username'],
              password: jsonRes['user']['password'],
              name: jsonRes['user']['name'],
              status: jsonRes['user']['status'],
              avatar: jsonRes['user']['avatar'] ??
                  ""
                      'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg',
            ),
          ),
        );
      } else {
        _showSnackBar('Login failed: ${jsonRes['message']}');
      }
    } catch (error) {
      _showSnackBar('An error occurred during login.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),

                // const SizedBox(height: 8),
                // ElevatedButton(
                //   onPressed: _forget,
                //   child: const Text('Forgot Password'),
                // ),

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
