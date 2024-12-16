
import 'package:flutter/material.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_description_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_image_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_location_map_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_price_info_widget.dart';

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
              clipBehavior: Clip.none,
              children: [
                HouseImageSection(
                    imageUrl: '${Constants.mainUrl}${house.image}', id: house.id,),
                Positioned(
                  bottom: 0, // Align to bottom of the image
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ), // Rounded corners
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HousePriceInfo(
                      price: formatCurrency(house.price),
                      bedrooms: house.bedrooms,
                      bathrooms: house.bathrooms,
                      size: house.size,
                      distanceFromUser: house.distanceFromUser,
                    ),
                    const SizedBox(height: 30),
                    HouseDescription(description: house.description),
                    const SizedBox(height: 16),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    HouseLocationMap(
                      latitude: house.latitude,
                      longitude: house.longitude,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}