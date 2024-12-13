// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) => House(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      price: (json['price'] as num).toInt(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      description: json['description'] as String,
      zip: json['zip'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdDate: json['createdDate'] as String,
    );

Map<String, dynamic> _$HouseToJson(House instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'price': instance.price,
      'bedrooms': instance.bedrooms,
      'size': instance.size,
      'description': instance.description,
      'zip': instance.zip,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdDate': instance.createdDate,
    };
