import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_test/app/app_keys.dart';

import '../../../app/app_routes.dart';
import '../../../data/models/product.dart';
import '../viewmodel/home_viewmodel.dart';
import 'all_products_view.dart';
import 'favorite_products_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Current selected index for bottom navigation

  // List of widgets for each tab in the bottom navigation
  static const List<Widget> _widgetOptions = <Widget>[
    AllProductsView(), // First tab: All Products
    FavoriteProductsView(), // Second tab: Favorite Products
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everest Shop'), // App bar title
        actions: [
          // Add product button in the app bar
          IconButton(
            key: AppKeys.addProductButtonKey, // Key for testing
            icon: const Icon(Icons.add_circle_outline), // Add icon
            onPressed: () async {
              // Navigate to AddProductScreen and wait for result
              final result = await Navigator.of(context).pushNamed(AppRoutes.addProduct);
              if (result != null && result is Product) {
                // If a new product was added, update the list in HomeViewModel
                if (mounted) {
                  Provider.of<HomeViewModel>(context, listen: false).addNewProduct(result);
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Display the selected tab's content
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Bottom navigation bar items
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on), // Icon for All Products
            label: 'All Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Icon for Favorites
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected item
        selectedItemColor: Theme.of(context).primaryColor, // Color for selected item
        onTap: _onItemTapped, // Callback for item taps
      ),
    );
  }
}
