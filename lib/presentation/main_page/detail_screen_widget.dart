import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/main_page/main_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
            HouseImageSection(imageUrl: '${Constants.mainUrl}${house.image}'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HousePriceInfo(
                    price: '\$${house.price}',
                    bedrooms: house.bedrooms,
                    bathrooms: house.bathrooms,
                    size: house.size,
                    distanceFromUser: house.distanceFromUser,
                  ),
                  const SizedBox(height: 20),
                  HouseDescription(description: house.description),
                  const SizedBox(height: 20),
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  HouseLocationMap(
                    latitude: house.latitude,
                    longitude: house.longitude,
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

class HouseImageSection extends StatelessWidget {
  final String imageUrl;

  const HouseImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
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
    );
  }
}

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
      children: [
        Text(
          price,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            IconWidget(imageString: AppImages.bed, string: '$bedrooms'),
            IconWidget(imageString: AppImages.shower, string: '$bathrooms'),
            IconWidget(imageString: AppImages.mapLayer, string: '$size'),
            IconWidget(
              imageString: AppImages.location,
              string: '${distanceFromUser?.toStringAsFixed(2) ?? '0'} km',
            ),
          ],
        ),
      ],
    );
  }
}

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
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

class HouseLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const HouseLocationMap(
      {super.key, required this.latitude, required this.longitude});

  Future<void> _openMap(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Open in Google Maps'),
                onTap: () async {
                  Navigator.pop(context);
                  await _openMapGoogle(context, position); // Pass position here
                },
              ),
              if (Platform.isIOS) ...[
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Open in Apple Maps'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _openAppleMap(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openMapGoogle(BuildContext context, Position position) async {
    final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$latitude,$longitude');

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Google Maps')),
      );
    }
  }

  Future<void> _openAppleMap(BuildContext context) async {
    final appleMapsUrl =
        Uri.parse('http://maps.apple.com/?daddr=$latitude,$longitude');
    try {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        throw 'Could not launch Apple Maps';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staticMapUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x300&markers=color:red|$latitude,$longitude&key=${Constants.apiKeyMaps}";

    return GestureDetector(
      onTap: () => _openMap(context), // Trigger map selection on tap
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            staticMapUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Unable to load map',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
