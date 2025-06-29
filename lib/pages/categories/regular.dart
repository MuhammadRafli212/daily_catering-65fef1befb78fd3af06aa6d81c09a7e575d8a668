import 'package:daily_catering/api/get_menu.dart';
import 'package:daily_catering/model/menu_model.dart';
import 'package:flutter/material.dart';

class RegularFoodPage extends StatefulWidget {
  final Function(Map<String, String>) onAddToChart;

  const RegularFoodPage({super.key, required this.onAddToChart});

  @override
  State<RegularFoodPage> createState() => _RegularFoodPageState();
}

class _RegularFoodPageState extends State<RegularFoodPage> {
  late Future<List<DataMenu>> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = GetMenu().fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Regular Food")),
      body: FutureBuilder<List<DataMenu>>(
        future: _menuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final menu = items[index];

              final String title = titleValues.reverse[menu.title] ?? menu.title.name;
              final String description = descriptionValues.reverse[menu.description] ?? menu.description.name;
              final String price = menu.price.toString();
              final String imageUrl = menu.imageUrl ?? 'https://asset.kompas.com/crops/VcgvggZKE2VHqIAUp1pyHFXXYCs=/202x66:1000x599/1200x800/data/photo/2023/05/07/6456a450d2edd.jpg';

              return Card(
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.fastfood),
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: Text('Rp $price'),
                  onTap: () {
                    widget.onAddToChart({
                      'title': title,
                      'price': price,
                      'description': description,
                      'imageUrl': imageUrl,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$title ditambahkan ke keranjang')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
