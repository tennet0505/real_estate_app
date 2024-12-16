import 'package:flutter/material.dart';

class HouseImageSection extends StatelessWidget {
  final String imageUrl;
  final int id;

  const HouseImageSection({super.key, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'tag_$id',
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 248,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 48,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
