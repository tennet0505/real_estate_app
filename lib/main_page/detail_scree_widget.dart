import 'package:flutter/material.dart';
import 'package:real_estate_app/Models/house.dart';
import 'package:real_estate_app/helpers/app_images.dart';
import 'package:real_estate_app/helpers/constants.dart';
import 'package:real_estate_app/main_page/main_page.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final house = ModalRoute.of(context)?.settings.arguments as House;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  '${Constants.mainUrl}${house.image}',
                  width: double.infinity,
                  height: 232,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${house.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          IconWidget(
                              imageString: AppImages.bed,
                              string: '${house.bedrooms}'),
                          IconWidget(
                              imageString: AppImages.shower,
                              string: '${house.bathrooms}'),
                          IconWidget(
                              imageString: AppImages.mapLayer,
                              string: '${house.size}'),
                          IconWidget(
                              imageString: AppImages.location,
                              string:
                                  '${house.distanceFromUser?.toStringAsFixed(2) ?? '0'} km'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    house.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  // Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300], // Placeholder for map
                    child: Center(
                      child: Text(
                        "house.location",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
