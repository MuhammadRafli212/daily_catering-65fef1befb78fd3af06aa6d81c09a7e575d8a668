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
      builder:
          (ctx) => AlertDialog(
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
                  Navigator.pop(ctx);
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

  Widget _buildStyledCard(
    Map<String, String> order,
    int index, {
    bool isDeleted = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: isDeleted ? Colors.red.shade50 : Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    order["image"] != null && order["image"]!.isNotEmpty
                        ? Image.network(
                          order["image"]!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 80,
                              ),
                        )
                        : const Icon(Icons.image, size: 80),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order["title"] ?? "-",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("Harga: ${order["price"] ?? "-"}"),
                    if (order.containsKey("status"))
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order["status"]!,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(index, isDeleted: isDeleted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cabe.jpg', // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                "Activity",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [Tab(text: "Complete"), Tab(text: "Cancel")],
              ),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Complete Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._orders.asMap().entries.map(
                        (entry) => _buildStyledCard(entry.value, entry.key),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Deleted Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._deletedOrders.asMap().entries.map(
                        (entry) => _buildStyledCard(
                          entry.value,
                          entry.key,
                          isDeleted: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
