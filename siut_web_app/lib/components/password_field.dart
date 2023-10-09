import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordHidden = true;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a password';
        }
        return null; // Return null if the input is valid
      },
      controller: controller,
      style: const TextStyle(color: Color(0xFFF5FCCD), fontFamily: 'Poppins'),
      obscureText: _isPasswordHidden,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
            color: Colors.red, // Customize the error message text color
            fontSize: 14.0, // Customize the error message text size
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold
            ),
        filled: true,
        fillColor: const Color(0xFF419197), // Background color
        hintText: 'Password', // Hint text
        hintStyle: const TextStyle(
          color: Color(0xFFF5FCCD),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
        ), // Hint text color
        border: const OutlineInputBorder(
          borderSide: BorderSide.none, // No border
          borderRadius: BorderRadius.all(Radius.circular(8.0)), // Border radius
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            // Toggle the password visibility
            setState(() {
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
          child: Icon(
            _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey, // Color of the toggle icon
          ),
        ),
      ),
    );
  }
}
