import 'package:flutter/material.dart';

class HistoryBar extends StatelessWidget {
  const HistoryBar({super.key, required this.text, required this.index, required this.onDelete, required this.onEdit});
  final String text;
  final int index;
  final Function(int) onDelete;
  final Function(String) onEdit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF12486B).withOpacity(0.9),
          ),
          // Background color of the container
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              const Icon(
                Icons.chat, // Chat icon
                color: Colors.white, // Icon color
                size: 18,
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 140,
                child: Text(
                  text, // Text
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 14.0,
                      fontFamily: 'Poppins'),
                ),
              ),
              const Spacer(), // To push edit and delete icons to the right
              IconButton(
                onPressed: () {
                  onEdit(text);
                },
                icon: const Icon(
                  Icons.edit, // Edit icon
                  color: Colors.white, // Icon color
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  onDelete(index);
                },
                icon: const Icon(
                  Icons.delete, // Delete icon
                  color: Colors.white, // Icon color
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
