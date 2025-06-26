import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_test/app/app_keys.dart';

import '../../../app/app_routes.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../viewmodel/login_viewmodel.dart'; // State management

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers for username and password fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Global key for the form to manage validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Title for the app bar
      ),
      body: Center(
        // Center the content on the screen
        child: SingleChildScrollView(
          // Allow scrolling if content overflows
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Form(
            key: _formKey, // Assign the form key
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically
                  children: [
                    // Application logo or icon
                    Icon(
                      Icons.shopping_bag,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 32), // Spacer
                    // Username input field
                    CustomTextField(
                      key: AppKeys.usernameFieldKey, // Key for testing
                      controller: _usernameController,
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      keyboardType: TextInputType.emailAddress, // Email keyboard type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onChanged: viewModel.setUsername, // Update view model on change
                    ),
                    const SizedBox(height: 16), // Spacer
                    // Password input field
                    CustomTextField(
                      key: AppKeys.passwordFieldKey, // Key for testing
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true, // Obscure text for password
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: viewModel.setPassword, // Update view model on change
                    ),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red), // Display error message in red
                        ),
                      ),
                    const SizedBox(height: 32), // Spacer
                    // Login button
                    if (viewModel.isLoading) const CircularProgressIndicator() else SizedBox(
                      width: double.infinity, // Button takes full width
                      height: 50, // Fixed height for the button
                      child: ElevatedButton(
                        key: AppKeys.loginButtonKey, // Key for testing
                        onPressed: () async {
                          // Validate form before attempting login
                          if (_formKey.currentState!.validate()) {
                            final success = await viewModel.login(); // Call login method
                            if (success) {
                              // Navigate to home screen on successful login
                              if (mounted) {
                                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                              }
                            } else {
                              // Error message is already handled by the Consumer and `viewModel.errorMessage`
                            }
                          }
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
