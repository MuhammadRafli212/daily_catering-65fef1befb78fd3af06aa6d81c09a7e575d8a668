import 'package:carousel_slider/carousel_slider.dart';
import 'package:daily_catering/api/get_menu.dart';
import 'package:daily_catering/model/menu_model.dart';
import 'package:daily_catering/pages/profil_page.dart';
import 'package:flutter/material.dart';

import 'chart.dart';
import 'order_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _cartItems = [];
  final List<Map<String, String>> _orders = [];
  final List<Map<String, String>> _deletedOrders = [];
  String? _selectedCategory;

  void _addToCart(Map<String, String> product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  void _deleteFromCart(int index) {
    setState(() {
      _deletedOrders.add(_cartItems[index]);
      _cartItems.removeAt(index);
    });
  }

  void _checkoutItems(List<Map<String, String>> items) {
    setState(() {
      _orders.addAll(items);
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      ChartPage(
        cartItems: _cartItems,
        onDelete: _deleteFromCart,
        onCheckout: _checkoutItems,
        deletedOrders: _deletedOrders,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bak.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Makan Bergizi Gratis",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Menu Makan Bergizi",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items:
                        [
                          'assets/images/waffle.jpg',
                          'assets/images/pan.jpg',
                          'assets/images/salad.jpg',
                          'assets/images/tongkol.jpg',
                          'assets/images/piz.jpg',
                          'assets/images/dbef.jpg',
                          'assets/images/lobster.jpg',
                          'assets/images/kun.jpg',
                        ].map((image) {
                          return Builder(
                            builder:
                                (context) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TODAY'S MEAL",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => OrderHistoryPage(
                                    orders: _orders,
                                    deletedOrders: _deletedOrders,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<DataMenu>>(
                    future: GetMenu().fetchMenuItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Terjadi kesalahan: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          "Tidak ada data menu tersedia.",
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      final menuList = snapshot.data!;
                      final filteredList =
                          _selectedCategory == null
                              ? menuList
                              : menuList
                                  .where(
                                    (item) =>
                                        item.category == _selectedCategory,
                                  )
                                  .toList();

                      final categories =
                          menuList
                              .map((e) => e.category ?? '')
                              .where((e) => e.isNotEmpty)
                              .toSet()
                              .toList();

                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              hint: const Text(
                                "Pilih Kategori",
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _selectedCategory,
                              onChanged:
                                  (val) =>
                                      setState(() => _selectedCategory = val),
                              items:
                                  categories.map((cat) {
                                    return DropdownMenuItem<String>(
                                      value: cat,
                                      child: Text(
                                        cat,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(filteredList.length, (index) {
                            final item = filteredList[index];
                            return TweenAnimationBuilder(
                              tween: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ),
                              duration: Duration(
                                milliseconds: 300 + (index * 100),
                              ),
                              curve: Curves.easeOut,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(0, offset.dy * 100),
                                  child: child,
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            item.imageUrl != null
                                                ? Image.network(
                                                  item.imageUrl!,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                )
                                                : const Icon(
                                                  Icons.image,
                                                  size: 60,
                                                ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              titleValues.reverse[item.title] ??
                                                  '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              descriptionValues.reverse[item
                                                      .description] ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Rp ${item.price}",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.green.shade800,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                            context,
                                                          ) => AlertDialog(
                                                            title: const Text(
                                                              "Konfirmasi",
                                                            ),
                                                            content: const Text(
                                                              "Tambahkan produk ini ke keranjang?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () => Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      "Batal",
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  _addToCart({
                                                                    "menu_id":
                                                                        item.id
                                                                            .toString(),
                                                                    "title":
                                                                        titleValues
                                                                            .reverse[item
                                                                            .title] ??
                                                                        '',
                                                                    "price":
                                                                        item.price
                                                                            .toString(),
                                                                    "store":
                                                                        item.category ??
                                                                        '',
                                                                    "image":
                                                                        item.imageUrl ??
                                                                        '',
                                                                  });
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Ya",
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      "Beli",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
