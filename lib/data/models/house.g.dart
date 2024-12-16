// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HouseAdapter extends TypeAdapter<House> {
  @override
  final int typeId = 0;

  @override
  House read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return House(
      fields[12] as double?,
      id: fields[0] as int,
      image: fields[1] as String,
      price: fields[2] as int,
      bedrooms: fields[3] as int,
      bathrooms: fields[4] as int,
      size: fields[5] as int,
      description: fields[6] as String,
      zip: fields[7] as String,
      city: fields[8] as String,
      latitude: fields[9] as double,
      longitude: fields[10] as double,
      createdDate: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, House obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.bedrooms)
      ..writeByte(4)
      ..write(obj.bathrooms)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.zip)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.latitude)
      ..writeByte(10)
      ..write(obj.longitude)
      ..writeByte(11)
      ..write(obj.createdDate)
      ..writeByte(12)
      ..write(obj.distanceFromUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) => House(
      (json['distanceFromUser'] as num?)?.toDouble(),
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      price: (json['price'] as num).toInt(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
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
      'bathrooms': instance.bathrooms,
      'size': instance.size,
      'description': instance.description,
      'zip': instance.zip,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdDate': instance.createdDate,
      'distanceFromUser': instance.distanceFromUser,
    };
