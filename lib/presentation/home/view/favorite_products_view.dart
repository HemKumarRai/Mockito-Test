import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For efficient image loading
// Home ViewModel
import 'package:provider/provider.dart';

import '../viewmodel/home_viewmodel.dart'; // State management

class FavoriteProductsView extends StatelessWidget {
  const FavoriteProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to changes in HomeViewModel
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        final favoriteProducts = homeViewModel.favoriteProducts; // Get favorite products list

        if (favoriteProducts.isEmpty) {
          return const Center(
            child: Text(
              'No favorite products yet. Add some from the All Products tab!', // Message if no favorites
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0), // Padding around the list
          itemCount: favoriteProducts.length, // Number of favorite items
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Vertical margin for cards
              elevation: 4, // Card shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding inside the card
                child: Row(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for image
                      child: CachedNetworkImage(
                        imageUrl: product.productImage,
                        width: 80, // Fixed width for image
                        height: 80, // Fixed height for image
                        fit: BoxFit.cover, // Cover the available space
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 12), // Spacer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text(
                            product.name, // Product name
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 2, // Max two lines for name
                            overflow: TextOverflow.ellipsis, // Ellipsis if overflows
                          ),
                          const SizedBox(height: 4), // Spacer
                          Text(
                            '\$${product.price}', // Product price
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4), // Spacer
                          Text(
                            'Quantity: ${product.quantity}', // Product quantity
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Favorite button to remove from favorites
                    IconButton(
                      key: ValueKey('favoriteListButton_${product.id}'), // Key for testing
                      icon: const Icon(
                        Icons.favorite, // Always solid favorite icon in favorites list
                        color: Colors.red, // Red color
                      ),
                      onPressed: () {
                        homeViewModel.toggleFavorite(product); // Remove from favorites
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
