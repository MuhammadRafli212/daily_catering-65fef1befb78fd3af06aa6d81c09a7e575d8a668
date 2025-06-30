import 'dart:convert';

import 'package:daily_catering/pages/order_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChartPage extends StatefulWidget {
  final List<Map<String, String>> cartItems;
  final Function(int) onDelete;
  final Function(List<Map<String, String>>) onCheckout;
  final List<Map<String, String>> deletedOrders;

  const ChartPage({
    super.key,
    required this.cartItems,
    required this.onDelete,
    required this.onCheckout,
    required this.deletedOrders,
  });

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final TextEditingController _addressController = TextEditingController();

  Future<void> _checkout(BuildContext context) async {
    if (widget.cartItems.isEmpty) return;

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat pengiriman wajib diisi.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await _sendCheckoutRequest();

    Navigator.pop(context); // Close loading dialog

    if (success) {
      widget.onCheckout(widget.cartItems);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => OrderHistoryPage(
                orders:
                    widget.cartItems
                        .map(
                          (item) => {
                            ...item,
                            "address": _addressController.text,
                            "status": "Pending",
                          },
                        )
                        .toList(),
                deletedOrders: widget.deletedOrders,
              ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Gagal Checkout"),
              content: const Text("Terjadi kesalahan saat mengirim pesanan."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  Future<bool> _sendCheckoutRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan");

      final List<Map<String, dynamic>> itemsWithStatus =
          widget.cartItems
              .map(
                (item) => {
                  ...item,
                  "address": _addressController.text,
                  "status": "Pending",
                },
              )
              .toList();

      final response = await http.post(
        Uri.parse('http://appkaterings.mobileprojp.com/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'items': itemsWithStatus}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Checkout Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chart")),
      body:
          widget.cartItems.isEmpty
              ? const Center(child: Text("Tidak ada produk dalam chart."))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = widget.cartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading:
                                product["image"] != null
                                    ? Image.network(
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.food_bank_sharp),
                                      product["image"]!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                    : const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                    ),
                            title: Text(
                              product["title"] ?? "Produk tanpa nama",
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Toko: ${product["store"] ?? "-"}"),
                                const SizedBox(height: 4),
                                Text(
                                  product["price"] ?? "Rp -",
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => widget.onDelete(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Alamat Pengiriman",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () => _checkout(context),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Checkout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
