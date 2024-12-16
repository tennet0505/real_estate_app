import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                HouseImageSection(
                    imageUrl: '${Constants.mainUrl}${house.image}'),
                Positioned(
                  bottom: 0, // Align to bottom of the image
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColor.lightGrayColor, // White background
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
              color: AppColor.lightGrayColor,
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
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
          height: 248,
          fit: BoxFit.cover,
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconWidget(
                imageString: AppImages.bed, string: '$bedrooms', isDetailScreen: true),
            IconWidget(
                imageString: AppImages.shower, string: '$bathrooms', isDetailScreen: true),
            IconWidget(
                imageString: AppImages.mapLayer, string: '$size', isDetailScreen: true),
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

class HouseLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const HouseLocationMap(
      {super.key, required this.latitude, required this.longitude});

  Future<void> _openMap(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Open in Google Maps'),
                onTap: () async {
                  Navigator.pop(context);
                  await _openMapGoogle(context, position);
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
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
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
