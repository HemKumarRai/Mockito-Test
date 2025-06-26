import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product.dart';
import '../viewmodel/home_viewmodel.dart'; // State management

class ProductGridItem extends StatelessWidget {
  final Product product; // The product to display

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to changes in HomeViewModel
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        final isFav = homeViewModel.isFavorite(product); // Check if product is a favorite
        return Card(
          elevation: 4, // Card shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)), // Rounded top corners for image
                  child: CachedNetworkImage(
                    imageUrl: product.productImage, // Image URL
                    fit: BoxFit.cover, // Cover the available space
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()), // Placeholder while loading
                    errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)), // Error icon if image fails to load
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), // Padding around text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                  children: [
                    Text(
                      product.name, // Product name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1, // Max one line for name
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                    const SizedBox(height: 4), // Spacer
                    Text(
                      '\$${product.price}', // Product price
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4), // Spacer
                    Text(
                      'Quantity: ${product.quantity}', // Product quantity
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight, // Align favorite button to bottom right
                child: IconButton(
                  key: ValueKey('favoriteButton_${product.id}'), // Key for testing
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border, // Favorite icon
                    color: isFav ? Colors.red : null, // Red if favorite
                  ),
                  onPressed: () {
                    homeViewModel.toggleFavorite(product); // Toggle favorite status
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}