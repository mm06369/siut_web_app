import 'package:flutter/material.dart';


class TypingIndicator extends StatelessWidget {
  final AnimationController controller;

  const TypingIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.drive(
        CurveTween(curve: Curves.easeInOut),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              // strokeWidth: 2,
            ),
          ),
          SizedBox(width: 8),
          Text('Typing...', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 20),),
        ],
      ),
    );
  }
}
