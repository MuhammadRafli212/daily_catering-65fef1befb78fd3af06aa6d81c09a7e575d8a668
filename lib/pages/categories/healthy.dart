// fast.dart
import 'package:flutter/material.dart';

class HealthyFoodPage extends StatelessWidget {
  final void Function(Map<String, String>) onAddToChart;

  const HealthyFoodPage({super.key, required this.onAddToChart});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        "image": "assets/images/salad.jpg",
        "title": "Fresh Green Salad",
        "price": "Rp18.000",
        "store": "Healthy Bites",
      },
      {
        "image": "assets/images/bbq.jpg",
        "title": "BBQ Chicken Salad",
        "price": "Rp22.000",
        "store": "Vita Boost",
      },
      {
        "image": "assets/images/avo.jpg",
        "title": "Grilled Corn Salad With Avocado",
        "price": "Rp22.000",
        "store": "Vita Boost",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Fast Food')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Image.asset(product["image"]!, width: 60, height: 60),
              title: Text(product["title"]!),
              subtitle: Text(product["price"]!),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Tambahkan ke Chart?"),
                          content: Text(
                            "Tambahkan ${product["title"]} ke chart?",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Batal"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: const Text("Ya"),
                              onPressed: () {
                                onAddToChart(product);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
