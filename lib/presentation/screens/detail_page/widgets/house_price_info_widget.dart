import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';
import 'package:real_estate_app/presentation/widgets/icon_widget.dart';

class HousePriceInfo extends StatelessWidget {
  final String price;
  final int bedrooms;
  final int bathrooms;
  final int size;
  final double? distanceFromUser;

  const HousePriceInfo({
    super.key,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.distanceFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        Row(
          children: [
            IconWidget(
                imageString: AppImages.bed,
                string: '$bedrooms',
                isDetailScreen: true),
            IconWidget(
                imageString: AppImages.shower,
                string: '$bathrooms',
                isDetailScreen: true),
            IconWidget(
                imageString: AppImages.mapLayer,
                string: '$size',
                isDetailScreen: true),
            IconWidget(
                imageString: AppImages.location,
                string: formatDistance(distanceFromUser),
                isDetailScreen: true),
          ],
        ),
      ],
    );
  }
}