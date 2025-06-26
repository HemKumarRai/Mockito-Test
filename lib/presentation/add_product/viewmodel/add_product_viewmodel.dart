import 'package:flutter/material.dart';
import '../../../data/models/product.dart';
import '../../../domain/usecases/add_product_usecase.dart'; // Use case to add product

enum AddProductState { initial, loading, success, error } // States for add product screen

class AddProductViewModel extends ChangeNotifier {
  final AddProductUseCase _addProductUseCase; // Use case for adding products

  AddProductViewModel(this._addProductUseCase);

  AddProductState _state = AddProductState.initial; // Current state
  String? _errorMessage; // Error message if any

  // Getters for state variables
  AddProductState get state => _state;
  String? get errorMessage => _errorMessage;

  // Adds a new product to the database
  Future<void> addProduct({
    required String productImage,
    required String name,
    required String price,
    required String quantity,
  }) async {
    _state = AddProductState.loading; // Set state to loading
    _errorMessage = null; // Clear previous error messages
    notifyListeners(); // Notify listeners to show loading indicator

    try {
      // Create a new Product object
      final newProduct = Product(
        productImage: productImage,
        name: name,
        price: price,
        quantity: quantity,
      );

      await _addProductUseCase.call(newProduct); // Execute use case to add product
      _state = AddProductState.success; // Set state to success
    } catch (e) {
      _errorMessage = 'Failed to add product: $e'; // Set error message
      _state = AddProductState.error; // Set state to error
    } finally {
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Resets the state of the ViewModel
  void resetState() {
    _state = AddProductState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}