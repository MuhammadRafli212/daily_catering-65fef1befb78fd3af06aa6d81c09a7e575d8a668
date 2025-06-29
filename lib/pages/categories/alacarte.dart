// Contoh File: categories/regular.dart
import 'package:daily_catering/api/api_service.dart';
import 'package:daily_catering/model/test_model.dart';
import 'package:flutter/material.dart';

class AlaCartePage extends StatefulWidget {
  final void Function(Map<String, String>) onAddToChart;

  const AlaCartePage({super.key, required this.onAddToChart});

  @override
  State<AlaCartePage> createState() => _RegularFoodPageState();
}

class _RegularFoodPageState extends State<AlaCartePage> {
  late Future<List<FoodItem>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = ApiService.fetchCategoryItems('regular');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ala Carte')),
      body: FutureBuilder<List<FoodItem>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Card(
                child: ListTile(
                  leading: Image.network(product.image, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(product.title),
                  subtitle: Text(product.price),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                    onPressed: () {
                      widget.onAddToChart(product.toMap());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}