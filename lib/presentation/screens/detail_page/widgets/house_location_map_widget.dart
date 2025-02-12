import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:url_launcher/url_launcher.dart';

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
      if (!context.mounted) return;  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: (Text(AppLocal.locationServicesAreDisabled.tr())),
      ));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (!context.mounted) return;  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: (Text(AppLocal.locationPermissionDenied.tr())),
      ));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!context.mounted) return;  
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons. map),
                title: Text(AppLocal.openInGoogleMaps.tr()),
                onTap: () async {
                  Navigator.pop(context);
                  await _openMapGoogle(context, position);
                },
              ),
              if (Platform.isIOS) ...[
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text(AppLocal.openInAppleMaps.tr()),
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocal.unableToOpenGoogleMaps.tr(),)),
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Apple Maps')),
      );
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
          color: Colors.transparent,
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
                  AppLocal.unableToLoadMap.tr(),
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
