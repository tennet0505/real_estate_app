import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart' as cluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with cluster.ClusterItem {
  final LatLng latLng;
  final String name;
  final String imageUrl;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int size;
  final String description;
  final String zip;
  final String city;
  final double latitude;
  final double longitude;
  final String createdDate;

  Place({
    required this.latLng,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.description,
    required this.zip,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdDate,
  });

  @override
  LatLng get location => latLng;
}
