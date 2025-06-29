import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  final List<Map<String, String>> orders;
  final List<Map<String, String>> deletedOrders;

  const OrderHistoryPage({
    super.key,
    required this.orders,
    required this.deletedOrders,
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late List<Map<String, String>> _orders;
  late List<Map<String, String>> _deletedOrders;

  @override
  void initState() {
    super.initState();
    _orders = List<Map<String, String>>.from(widget.orders);
    _deletedOrders = List<Map<String, String>>.from(widget.deletedOrders);
  }

  void _confirmDelete(int index, {bool isDeleted = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pesanan?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pesanan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              _deleteOrder(index, isDeleted: isDeleted);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteOrder(int index, {bool isDeleted = false}) {
    setState(() {
      if (isDeleted) {
        _deletedOrders.removeAt(index);
      } else {
        _orders.removeAt(index);
      }
    });
  }

  Widget _buildOrderCard(
    Map<String, String> order,
    int index, {
    bool isDeleted = false,
  }) {
    return Card(
      color: isDeleted ? Colors.red.shade50 : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.asset(
          order["image"] ?? "",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(order["title"] ?? "-"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Harga: ${order["price"] ?? "-"}"),
            if (order.containsKey("address"))
              Text("Alamat: ${order["address"]}"),
            if (order.containsKey("status"))
              Text("Status: ${order["status"]}"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(index, isDeleted: isDeleted),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Completed Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._orders.asMap().entries.map(
                (entry) => _buildOrderCard(entry.value, entry.key),
              ),
          const SizedBox(height: 24),
          const Text(
            "Deleted Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._deletedOrders.asMap().entries.map(
                (entry) =>
                    _buildOrderCard(entry.value, entry.key, isDeleted: true),
              ),
        ],
      ),
    );
  }
}
