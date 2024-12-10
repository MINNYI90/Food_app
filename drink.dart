import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrinkCart extends StatefulWidget {
  const DrinkCart({super.key});

  @override
  State<StatefulWidget> createState() => _DrinkCartState();
}

class _DrinkCartState extends State<DrinkCart> {
  List<dynamic> _drinkItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDrinkItems();
  }

  Future<void> _fetchDrinkItems() async {
    try {
      final url = Uri.parse('https://apifood-gules.vercel.app/food_and_drinks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _drinkItems =
              data.where((item) => item['category'] == 'Drink').toList();
        });
      } else {
        throw Exception('Failed to load drink items');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_drinkItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _drinkItems.length,
      itemBuilder: (context, index) {
        final item = _drinkItems[index];
        return Card(
          child: ListTile(
            leading: Image.network(
              item['image_url'] ?? 'https://via.placeholder.com/50',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item['name'] ?? 'Unknown'),
            subtitle: Text('\$${item['price'] ?? '0.00'}'),
          ),
        );
      },
    );
  }
}
