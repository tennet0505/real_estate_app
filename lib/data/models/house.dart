import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:real_estate_app/presentation/maps/map.dart';

part 'house.g.dart';

@HiveType(typeId: 0) // Unique type ID for Hive
@JsonSerializable()
class House {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final int bedrooms;

  @HiveField(4)
  final int bathrooms;

  @HiveField(5)
  final int size;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String zip;

  @HiveField(8)
  final String city;

  @HiveField(9)
  final double latitude;

  @HiveField(10)
  final double longitude;

  @HiveField(11)
  final String createdDate;

  @HiveField(12)
  double? distanceFromUser;

  House(
    this.distanceFromUser, {
    required this.id,
    required this.image,
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

  // JSON serialization
  factory House.fromJson(Map<String, dynamic> json) => _$HouseFromJson(json);
  Map<String, dynamic> toJson() => _$HouseToJson(this);

}
