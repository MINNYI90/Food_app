import 'package:flutter/material.dart';
import 'package:flutter_final_food_update/food.dart';
import 'package:flutter_final_food_update/drink.dart';
import 'package:flutter_final_food_update/login_screen.dart';

class TabeMenuPage extends StatefulWidget {
  final String username;
  final String password;
  final String name;
  final String status;
  final String? avatar;

  const TabeMenuPage({
    super.key,
    required this.username,
    required this.password,
    required this.name,
    required this.status,
    this.avatar,
  });

  @override
  State<StatefulWidget> createState() => _TabeMenuPageState();
}

class _TabeMenuPageState extends State<TabeMenuPage> {
  late List<dynamic> _cart;

  @override
  void initState() {
    super.initState();
    _cart = []; // Initialize the cart here
  }

  void _onOrderPlaced() {
    setState(() {
      _cart.clear(); // Clear the cart when the order is placed
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Delivery'),
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
            FoodCart(
                cart: _cart,
                onOrderPlaced: _onOrderPlaced), // Pass cart to FoodCart
            DrinkCart(
                cart: _cart,
                onOrderPlaced: _onOrderPlaced), // Pass cart to DrinkCart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Name: ${widget.name}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Email: ${widget.username}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.network(
                        widget.avatar ?? '', // Use empty string if null
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/placeholder_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
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

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
