import 'package:flutter/material.dart';
import 'order_summery.dart'; // Import the OrderConfirmationPage

class CheckoutPage extends StatefulWidget {
  final List<dynamic> cart;
  final Function onOrderPlaced;

  const CheckoutPage({
    super.key,
    required this.cart,
    required this.onOrderPlaced,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cart.map((item) {
      if (item is Map<String, dynamic>) {
        return {
          ...item,
          'quantity': 1,
        };
      } else {
        return <String, dynamic>{
          'name': 'Unknown',
          'price': 0.0,
          'quantity': 1,
        };
      }
    }).toList();
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      double itemPrice = double.tryParse(item['price'].toString()) ?? 0.0;
      total += itemPrice * (item['quantity'] ?? 1);
    }
    return total;
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _navigateToOrderConfirmationPage() {
    double totalAmount = _calculateTotal();
    String imageUrl = cartItems.isNotEmpty
        ? cartItems[0]['image_url'] ?? 'https://via.placeholder.com/150'
        : 'https://via.placeholder.com/150';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          totalAmount: totalAmount,
          imageUrl: imageUrl,
          onOrderNow: () {
            widget.onOrderPlaced(); // Clear the cart when the order is placed
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Order placed successfully!')),
            // );
          },
          onOrderAgain: () {
            Navigator.pop(context); // Go back to tab menu or home page
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item['image_url'] ?? 'https://via.placeholder.com/50',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name'] ?? 'Unknown'),
                    subtitle: Text('\$${item['price']} x ${item['quantity']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () => _decreaseQuantity(index),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _increaseQuantity(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            _removeItem(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : _navigateToOrderConfirmationPage,
                  child: const Text('Place Order'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
