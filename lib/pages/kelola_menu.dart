import 'dart:convert';

import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/endpoint/endpoint.dart';
import 'package:daily_catering/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KelolaMenuPage extends StatefulWidget {
  const KelolaMenuPage({super.key});

  @override
  State<KelolaMenuPage> createState() => _KelolaMenuPageState();
}

class _KelolaMenuPageState extends State<KelolaMenuPage> {
  List<DataMenu> menuList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    setState(() => isLoading = true);
    try {
      final token = await PreferencesHelper.getToken();
      final response = await http.get(
        Uri.parse(Endpoint.menus),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body)['data'];
        final List<DataMenu> fetched =
            dataList.map((e) => DataMenu.fromJson(e)).toList();
        setState(() {
          menuList = fetched;
        });
      } else {
        throw Exception("Gagal mengambil menu");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> tambahMenu(String title, String price) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.menus),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"title": title, "price": price}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchMenus();
    } else {
      throw Exception("Gagal menambahkan menu");
    }
  }

  Future<void> updateMenu(int id, String title, String price) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.put(
      Uri.parse('${Endpoint.menus}/$id'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"title": title, "price": price}),
    );

    if (response.statusCode == 200) {
      fetchMenus();
    } else {
      throw Exception("Gagal memperbarui menu");
    }
  }

  Future<void> hapusMenu(int id) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.delete(
      Uri.parse('${Endpoint.menus}/$id'),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      fetchMenus();
    } else {
      throw Exception("Gagal menghapus menu");
    }
  }

  void showFormDialog({DataMenu? menu}) {
    if (menu != null) {
      _titleController.text = titleValues.reverse[menu.title] ?? '';
      _priceController.text = menu.price.toString();
    } else {
      _titleController.clear();
      _priceController.clear();
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(menu == null ? 'Tambah Menu' : 'Edit Menu'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Nama Menu'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final price = _priceController.text.trim();
                  if (title.isEmpty || price.isEmpty) return;

                  Navigator.pop(context);

                  if (menu == null) {
                    await tambahMenu(title, price);
                  } else {
                    await updateMenu(menu.id, title, price);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C5470),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Kelola Menu Makanan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchMenus,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menuList.length,
                  itemBuilder: (context, index) {
                    final menu = menuList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(titleValues.reverse[menu.title] ?? '-'),
                        subtitle: Text("Rp ${menu.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showFormDialog(menu: menu),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => hapusMenu(menu.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFormDialog(),
        backgroundColor: const Color(0xFF5C5470),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
