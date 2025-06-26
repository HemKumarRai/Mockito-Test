import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast messages
import 'package:provider/provider.dart';
import 'package:test_test/app/app_keys.dart';

import '../../../data/models/product.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../viewmodel/add_product_viewmodel.dart'; // State management

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Text editing controllers for each input field
  final TextEditingController _productImageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Global key for the form to manage validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _productImageController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // Function to show a toast message
  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the form
        child: Form(
          key: _formKey, // Assign the form key
          child: Consumer<AddProductViewModel>(
            builder: (context, viewModel, child) {
              // Listen for state changes to show success/error messages
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (viewModel.state == AddProductState.success) {
                  _showToast('Product added successfully!');
                  // Pop the screen and pass the new product back
                  // Note: We don't have the generated ID from Firebase directly here
                  // so we pass a Product without an ID. The HomeScreen will need to re-fetch
                  // or handle this product being added to its local list.
                  Navigator.of(context).pop(Product(
                    name: _nameController.text,
                    price: _priceController.text,
                    productImage: _productImageController.text,
                    quantity: _quantityController.text,
                  ));
                  viewModel.resetState(); // Reset state after showing toast
                } else if (viewModel.state == AddProductState.error) {
                  _showToast(viewModel.errorMessage ?? 'Failed to add product.', isError: true);
                  viewModel.resetState(); // Reset state after showing toast
                }
              });

              return SingleChildScrollView(
                // Allow scrolling if content overflows
                child: Column(
                  children: [
                    // Product Image URL input
                    CustomTextField(
                      key:AppKeys.productImageFieldKey, // Key for testing
                      controller: _productImageController,
                      labelText: 'Product Image URL',
                      hintText: 'e.g., https://example.com/image.jpg',
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product image URL';
                        }
                        if (!Uri.tryParse(value)!.hasAbsolutePath ) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),
                    // Product Name input
                    CustomTextField(
                      key: AppKeys.productNameFieldKey, // Key for testing
                      controller: _nameController,
                      labelText: 'Product Name',
                      hintText: 'e.g., Laptop, Smartphone',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    // Product Price input
                    CustomTextField(
                      key:AppKeys.productPriceFieldKey, // Key for testing
                      controller: _priceController,
                      labelText: 'Price',
                      hintText: 'e.g., 50000',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product price';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Please enter a valid positive price';
                        }
                        return null;
                      },
                    ),
                    // Product Quantity input
                    CustomTextField(
                      key:AppKeys.productQuantityFieldKey, // Key for testing
                      controller: _quantityController,
                      labelText: 'Quantity',
                      hintText: 'e.g., 10, 50',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product quantity';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Please enter a valid positive quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24), // Spacer
                    // Add Product button
                    viewModel.state == AddProductState.loading
                        ? const LoadingIndicator() // Show loading indicator
                        : SizedBox(
                      width: double.infinity, // Button takes full width
                      height: 50, // Fixed height for button
                      child: ElevatedButton(
                        key: AppKeys.addProductButtonKey, // Key for testing
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Call addProduct method in ViewModel
                            viewModel.addProduct(
                              productImage: _productImageController.text,
                              name: _nameController.text,
                              price: _priceController.text,
                              quantity: _quantityController.text,
                            );
                          }
                        },
                        child: const Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
