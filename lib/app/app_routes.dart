import 'package:flutter/material.dart';

import '../presentation/add_product/view/add_product_screen.dart';
import '../presentation/auth/view/login_screen.dart';
import '../presentation/home/view/home_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String addProduct = '/add_product';
  AppRoutes._();

  // Map of route names to their corresponding widget builders
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(), // Login screen is the initial route
    home: (context) => const HomeScreen(),   // Home screen after successful login
    addProduct: (context) => const AddProductScreen(), // Screen to add new products
  };
}
