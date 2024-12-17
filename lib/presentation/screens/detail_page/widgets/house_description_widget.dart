import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';

class HouseDescription extends StatelessWidget {
  final House house; // Add a houseId to identify the specific house
  final bool isFavorite;

  const HouseDescription(
      {super.key, required this.house, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    // Check if the state has the favorite house ids
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFavorite
                    ? Colors.red
                    : Theme.of(context).textTheme.titleLarge?.color,
              ),
              onPressed: () {
                // Toggle favorite status
                context
                    .read<HouseBloc>()
                    .add(ToggleFavoriteHouseEvent(house.id));
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          house.description,
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
