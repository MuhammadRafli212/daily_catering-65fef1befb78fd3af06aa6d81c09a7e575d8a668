import 'package:carousel_slider/carousel_slider.dart';
import 'package:daily_catering/pages/order_history.dart';
import 'package:flutter/material.dart';

import 'categories/alacarte.dart';
import 'categories/fast.dart';
import 'categories/healthy.dart';
import 'categories/other.dart';
import 'categories/regular.dart';
import 'categories/seafood.dart';
import 'chart.dart';

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
      HomeContent(
        onAddToCart: _addToCart,
        onViewOrders: () {
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
      ChartPage(
        cartItems: _cartItems,
        onDelete: _deleteFromCart,
        onCheckout: _checkoutItems,
        deletedOrders: _deletedOrders,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6F5F5),
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
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Function(Map<String, String>) onAddToCart;
  final VoidCallback onViewOrders;

  const HomeContent({
    super.key,
    required this.onAddToCart,
    required this.onViewOrders,
  });

  @override
  Widget build(BuildContext context) {
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
                    "Good Morning, Maspay",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search food, package etc.',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 150,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items:
                        [
                          'assets/images/avo.jpg',
                          'assets/images/salad.jpg',
                          'assets/images/crab.jpg',
                          'assets/images/lobster.jpg',
                          'assets/images/tongkol.jpg',
                          'assets/images/rendang.jpeg',
                          'assets/images/waffle.jpg',
                          'assets/images/pan.jpg',
                          'assets/images/bbq.jpg',
                        ].map((i) {
                          return Builder(
                            builder:
                                (context) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    i,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: onViewOrders,
                    icon: const Icon(Icons.history),
                    label: const Text("Order History"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildCategory(
                        context,
                        "assets/images/buffet.png",
                        "Regular\nFood",
                        RegularFoodPage(onAddToChart: onAddToCart),
                      ),
                      _buildCategory(
                        context,
                        "assets/images/cat.png",
                        "Sea\nFood",
                        SeaFoodPage(onAddToChart: onAddToCart),
                      ),
                      _buildCategory(
                        context,
                        "assets/images/cloche.png",
                        "Healthy\nFood",
                        HealthyFoodPage(onAddToChart: onAddToCart),
                      ),
                      _buildCategory(
                        context,
                        "assets/images/chef.png",
                        "FastFood",
                        FastFoodPage(onAddToChart: onAddToCart),
                      ),
                      _buildCategory(
                        context,
                        "assets/images/event.png",
                        "Ala\nCarte",
                        AlaCartePage(onAddToChart: onAddToCart),
                      ),
                      _buildCategory(
                        context,
                        "assets/images/other.png",
                        "Others",
                        OthersPage(onAddToChart: onAddToCart),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String imagePath,
    String label,
    Widget page,
  ) {
    return InkWell(
      onTap:
          () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
