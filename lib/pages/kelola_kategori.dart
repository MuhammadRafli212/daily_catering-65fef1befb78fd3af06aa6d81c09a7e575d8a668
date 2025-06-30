import 'dart:convert';

import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/endpoint/endpoint.dart';
import 'package:daily_catering/model/create_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KelolaKategoriPage extends StatefulWidget {
  const KelolaKategoriPage({super.key});

  @override
  State<KelolaKategoriPage> createState() => _KelolaKategoriPageState();
}

class _KelolaKategoriPageState extends State<KelolaKategoriPage> {
  List<Data> kategoriList = [];
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() => isLoading = true);
    try {
      final token = await PreferencesHelper.getToken();
      final response = await http.get(
        Uri.parse(Endpoint.categories),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body)['data'];
        final List<Data> fetched =
            dataList.map((e) => Data.fromJson(e)).toList();
        setState(() {
          kategoriList = fetched;
        });
      } else {
        throw Exception("Gagal mengambil kategori");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> tambahKategori(String name) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.categories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchCategories();
    } else {
      throw Exception("Gagal menambahkan kategori");
    }
  }

  Future<void> updateKategori(int id, String name) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.put(
      Uri.parse('${Endpoint.categories}/$id'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name}),
    );

    if (response.statusCode == 200) {
      fetchCategories();
    } else {
      throw Exception("Gagal memperbarui kategori");
    }
  }

  Future<void> hapusKategori(int id) async {
    final token = await PreferencesHelper.getToken();
    final response = await http.delete(
      Uri.parse('${Endpoint.categories}/$id'),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      fetchCategories();
    } else {
      throw Exception("Gagal menghapus kategori");
    }
  }

  void showFormDialog({Data? kategori}) {
    if (kategori != null) {
      _nameController.text = kategori.name;
    } else {
      _nameController.clear();
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(kategori == null ? 'Tambah Kategori' : 'Edit Kategori'),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Kategori'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) return;

                  Navigator.pop(context);

                  if (kategori == null) {
                    await tambahKategori(name);
                  } else {
                    await updateKategori(kategori.id, name);
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
        title: const Text("Kelola Kategori Makanan"),
        backgroundColor: Colors.green.shade800,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchCategories,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = kategoriList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(kategori.name),
                        subtitle: Text("ID: ${kategori.id}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed:
                                  () => showFormDialog(kategori: kategori),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => hapusKategori(kategori.id),
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
        backgroundColor: Colors.green.shade800,
        child: const Icon(Icons.add),
      ),
    );
  }
}
