import 'package:daily_catering/api/get_menu.dart';
import 'package:flutter/material.dart';
import 'package:daily_catering/model/menu_model.dart';

class KelolaMenuPage extends StatefulWidget {
  const KelolaMenuPage({super.key});

  @override
  State<KelolaMenuPage> createState() => _KelolaMenuPageState();
}

class _KelolaMenuPageState extends State<KelolaMenuPage> {
  late Future<List<DataMenu>> _menuList;

  @override
  void initState() {
    super.initState();
    _refreshMenuList();
  }

  void _refreshMenuList() {
    _menuList = GetMenu().fetchMenuItems();
  }

  void _deleteMenu(int id) async {
    await GetMenu().deleteMenu(id);
    _refreshMenuList();
    setState(() {});
  }

  void _editMenu(DataMenu menu) {
    // Navigasi ke halaman edit dengan menu sebagai parameter
  }

  void _addMenu() {
    // Navigasi ke halaman tambah menu baru
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Menu Makanan'),
        backgroundColor: Colors.green.shade800,
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addMenu)],
      ),
      body: FutureBuilder<List<DataMenu>>(
        future: _menuList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data menu'));
          }

          final menus = snapshot.data!;
          return ListView.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final item = menus[index];
              return ListTile(
                title: Text(titleValues.reverse[item.title] ?? ''),
                subtitle: Text("Rp ${item.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editMenu(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteMenu(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
