import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_final_food_update/checkout.dart';

class FoodCart extends StatefulWidget {
  final List<dynamic> cart;
  final Function onOrderPlaced;

  const FoodCart({super.key, required this.cart, required this.onOrderPlaced});

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
      final url = Uri.parse('https://api-11-12.vercel.app/food_and_drinks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _foodItems =
              data.where((item) => item['category'] == 'Food').toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching food items: $e')),
      );
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      widget.cart.add(item);
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('${item['name']} added to cart!')),
    // );
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cart: widget.cart,
          onOrderPlaced: widget.onOrderPlaced,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_foodItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _foodItems.length,
            itemBuilder: (context, index) {
              final item = _foodItems[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    item['image_url'] ?? '',
                    width: 40,
                    height: 50,
                  ),
                  title: Text(item['name'] ?? ''),
                  subtitle: Text('\$${item['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () => _addToCart(item),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _checkout,
            child: const Text('Checkout'),
          ),
        ),
      ],
    );
  }
}
