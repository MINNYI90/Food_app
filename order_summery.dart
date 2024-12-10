import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final double totalAmount;
  final String imageUrl;
  final Function onOrderNow;
  final Function onOrderAgain;

  const OrderConfirmationPage({
    super.key,
    required this.totalAmount,
    required this.imageUrl,
    required this.onOrderNow,
    required this.onOrderAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/qr.jpg',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onOrderNow();
                Navigator.pop(context); // Go back to previous page
              },
              child: const Text('Return to Cart'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onOrderAgain();
                Navigator.pop(context); // Go back to tab menu or home page
              },
              child: const Text('Order Again'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
