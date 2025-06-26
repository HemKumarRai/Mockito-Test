import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller; // Controller for the text field
  final String labelText; // Label text for the input field
  final String hintText; // Hint text for the input field
  final bool obscureText; // Whether to obscure text (for passwords)
  final TextInputType keyboardType; // Keyboard type for input
  final FormFieldValidator<String>? validator; // Validator function for input validation
  final Widget? suffixIcon; // Optional suffix icon
  final Function(String)?onChanged;

  // Constructor for CustomTextField
  const CustomTextField({
    super.key,
     this.onChanged,
    required this.controller,
    required this.labelText,
    this.hintText = '', // Default empty hint text
    this.obscureText = false, // Default to not obscure text
    this.keyboardType = TextInputType.text, // Default keyboard type
    this.validator, // Optional validator
    this.suffixIcon, // Optional suffix icon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding
      child: TextFormField(
        onChanged:onChanged ,
        controller: controller, // Assign the text editing controller
        obscureText: obscureText, // Set obscure text property
        keyboardType: keyboardType, // Set keyboard type
        validator: validator, // Assign the validator function
        decoration: InputDecoration(
          labelText: labelText, // Label for the input field
          hintText: hintText, // Hint text for the input field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
            borderSide: BorderSide.none, // No visible border initially
          ),
          filled: true, // Fill the background of the input field
          fillColor: Colors.grey[200], // Background color
          suffixIcon: suffixIcon, // Optional suffix icon
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}

