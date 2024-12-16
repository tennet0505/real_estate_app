import 'package:flutter/material.dart';

class HouseDescription extends StatelessWidget {
  final String description;

  const HouseDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.titleLarge?.color,
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