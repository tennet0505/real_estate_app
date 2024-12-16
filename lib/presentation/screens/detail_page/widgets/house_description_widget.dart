import 'package:flutter/material.dart';

class HouseDescription extends StatelessWidget {
  final String description;

  const HouseDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            height: 1.3,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            fontFamily: 'GothamSSm',
          ),
        ),
      ],
    );
  }
}