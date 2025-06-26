import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/loading_indicator.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widget/product_grid_item.dart';

class AllProductsView extends StatefulWidget {
  const AllProductsView({super.key});

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consumer listens to changes in HomeViewModel
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        switch (homeViewModel.state) {
          case HomeState.loading:
            return const LoadingIndicator(); // Show loading indicator
          case HomeState.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(homeViewModel.errorMessage ?? 'An unknown error occurred.'), // Display error message
                  ElevatedButton(
                    onPressed: () => homeViewModel.fetchProducts(), // Retry button
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case HomeState.loaded:
            if (homeViewModel.allProducts.isEmpty) {
              return const Center(
                child: Text('No products found.'), // Message if no products
              );
            }
            return RefreshIndicator(
              onRefresh: () => homeViewModel.fetchProducts(), // Pull to refresh
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0), // Padding around the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns in the grid
                  crossAxisSpacing: 8.0, // Horizontal spacing between items
                  mainAxisSpacing: 8.0, // Vertical spacing between items
                  childAspectRatio: 0.75, // Aspect ratio of each grid item
                ),
                itemCount: homeViewModel.allProducts.length, // Number of items
                itemBuilder: (context, index) {
                  final product = homeViewModel.allProducts[index];
                  return ProductGridItem(product: product); // Display each product using ProductGridItem
                },
              ),
            );
          case HomeState.initial:
            return const SizedBox.shrink(); // Initially, show nothing or a splash screen
        }
      },
    );
  }
}
