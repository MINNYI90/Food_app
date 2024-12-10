import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodCart extends StatefulWidget {
  const FoodCart({super.key});

  @override
  State<StatefulWidget> createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  List<dynamic> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      final url = Uri.parse('https://apifood-gules.vercel.app/food_and_drinks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _foodItems =
              data.where((item) => item['category'] == 'Food').toList();
        });
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_foodItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _foodItems.length,
      itemBuilder: (context, index) {
        final item = _foodItems[index];
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
