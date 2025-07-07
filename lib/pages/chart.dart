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
  OverlayEntry? _popupEntry;

  Future<void> _confirmCheckout(BuildContext context) async {
    if (widget.cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi Checkout"),
            content: const Text(
              "Apakah Anda yakin ingin checkout semua pesanan?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tidak"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Tutup dialog konfirmasi
                  await _checkout(context); // Jalankan proses checkout
                },
                child: const Text("Ya"),
              ),
            ],
          ),
    );
  }

  Future<void> _checkout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await _sendCheckoutRequest();

    Navigator.pop(context); // Close loading dialog

    if (success) {
      widget.onCheckout(widget.cartItems);
      _showPopupNotification(context, "Order berhasil!");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => OrderHistoryPage(
                orders:
                    widget.cartItems
                        .map((item) => {...item, "status": "Pending"})
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

  void _showPopupNotification(BuildContext context, String message) {
    _popupEntry?.remove();

    _popupEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_popupEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _popupEntry?.remove();
      _popupEntry = null;
    });
  }

  Future<bool> _sendCheckoutRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan");

      for (var item in widget.cartItems) {
        final response = await http.post(
          Uri.parse('http://appkaterings.mobileprojp.com/api/orders'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'menu_id': int.tryParse(item['menu_id'] ?? '0') ?? 0,
            'delivery_address': 'Alamat Default',
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          return false;
        }
      }
      return true;
    } catch (e) {
      print("Checkout Error: $e");
      return false;
    }
  }

  double getTotalPrice() {
    return widget.cartItems.fold(0.0, (total, item) {
      final price = double.tryParse(item['price'] ?? '0') ?? 0.0;
      return total + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Order"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/cabe.jpg', fit: BoxFit.cover),
          ),
          widget.cartItems.isEmpty
              ? const Center(
                child: Text(
                  "Tidak ada produk dalam chart.",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
              : Column(
                children: [
                  const SizedBox(height: 90),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    item["image"] != null
                                        ? Image.network(
                                          item["image"]!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  const Icon(Icons.image),
                                        )
                                        : const Icon(Icons.image, size: 60),
                              ),
                              title: Text(item["title"] ?? "-"),
                              subtitle: Text("\$${item["price"] ?? "0"}"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => widget.onDelete(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total price",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "\$${getTotalPrice().toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _confirmCheckout(context),
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text("Checkout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
