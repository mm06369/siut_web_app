import 'package:flutter/material.dart';
import 'package:siut_web_app/components/password_field.dart';
import 'package:siut_web_app/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12486B),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              'SIUT Chatbot',
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF5FCCD)),
            )),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 4.8,
            ),
            const Center(
                child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF5FCCD)),
            )),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null; // Return null if the input is valid
                        },
                        controller: _usernameController,
                        style: const TextStyle(
                            color: Color(0xFFF5FCCD), fontFamily: 'Poppins'),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors
                                .red, // Customize the error message text color
                            fontSize:
                                14.0, // Customize the error message text size
                                fontFamily: 'Poppins'
                          ),
                          filled: true,
                          fillColor: Color(0xFF419197), // Background color
                          hintText: 'Username', // Hint text
                          hintStyle: TextStyle(
                              color: Color(0xFFF5FCCD),
                              fontFamily: 'Poppins'), // Hint text color
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none, // No border
                            borderRadius: BorderRadius.all(
                                Radius.circular(8.0)), // Border radius
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 300,
                        child: PasswordField(
                          controller: _passwordController,
                        )),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300.0, // Width of the button
              height: 50.0, // Height of the button
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, perform your action here
                    // Typically, this is where you'd submit the form data
                    setState(() {
                      _isVerifying = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 1000));
                    setState(() {
                      _isVerifying = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
                  } else {
                    // Form is not valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF5FCCD), // Background color
                  onPrimary: const Color(0xFF12486B), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Button border radius
                  ),
                ),
                child: !_isVerifying ? const Text(
                  'Sign In', // Button text
                  style: TextStyle(
                      fontSize: 18.0, // Text size
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600),
                ): CircularProgressIndicator(color: Color(0xFF12486B),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
