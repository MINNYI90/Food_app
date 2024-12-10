import 'package:flutter/material.dart';
import 'package:food/food.dart';
import 'package:food/drink.dart';
import 'package:food/login_screen.dart';

class TabeMenuPage extends StatefulWidget {
  final String username;
  final String password;
  final String name;
  final String status;

  const TabeMenuPage({
    super.key,
    required this.username,
    required this.password,
    required this.name,
    required this.status,
  });

  @override
  State<StatefulWidget> createState() => _TabeMenuPageState();
}

class _TabeMenuPageState extends State<TabeMenuPage> {
  late String _username;
  late String _name;
  late String _status;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _name = widget.name;
    _status = widget.status;

    // Debug prints
    print('Username: $_username');
    print('Name: $_name');
    print('Status: $_status');
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dante 6610299'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Foods', icon: Icon(Icons.fastfood)),
              Tab(text: 'Drinks', icon: Icon(Icons.liquor)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const FoodCart(),
            const DrinkCart(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('First name: $_name',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Last name: $_status',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(_username,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
