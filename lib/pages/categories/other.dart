// fast.dart
import 'package:flutter/material.dart';

class OthersPage extends StatelessWidget {
  final void Function(Map<String, String>) onAddToChart;

  const OthersPage({super.key, required this.onAddToChart});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        "image": "assets/images/pan.jpg",
        "title": "Strawberry Pancake",
        "price": "Rp15.000",
        "store": "SnackyTime",
      },
      {
        "image": "assets/images/waffle.jpg",
        "title": "Waffle",
        "price": "Rp15.000",
        "store": "SnackyTime",
      },
      {
        "image": "assets/images/rot.jpg",
        "title": "Snack Variety Box",
        "price": "Rp15.000",
        "store": "SnackyTime",
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
