import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_estate_app/data/clients/geo_client.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';

part 'house_event.dart';
part 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final HouseRepository repository;
  final List<House> _allHouses = [];
  final GeoClient geoClient = GeoClient();

  HouseBloc(this.repository) : super(const HouseLoadingState()) {
    on<GetHouses>((event, emit) async {
      emit(const HouseLoadingState());
      try {
        final houses = await repository.getHouses();
        
        final housesWithDistances = await calculateDistances(houses);

        _allHouses.clear();
        _allHouses.addAll(housesWithDistances);
        
        emit(HouseState(houses: housesWithDistances));
      } catch (e) {
        emit(HouseErrorState(e.toString()));
      }
    });

    on<SearchHouses>((event, emit) {
      final query = event.query.toLowerCase();
      if (query.isEmpty) {
        emit(HouseState(houses: _allHouses));
      } else {
        final filteredHouses = _allHouses.where((house) {
          final zip = house.zip.toLowerCase();
          final city = house.city.toLowerCase();
          return zip.contains(query) || city.contains(query);
        }).toList();
        emit(HouseState(houses: filteredHouses));
      }
    });
  }

  Future<List<House>> calculateDistances(List<House> houses) async {
    try {
      final position = await geoClient.getCurrentLocation();
      final userLat = position.latitude;
      final userLon = position.longitude;

      final _houses = houses.map((house) {
        final distance = geoClient.calculateDistance(
          userLat,
          userLon,
          house.latitude,
          house.longitude,
        );
        house.distanceFromUser = distance;  
        return house;
      }).toList();
      return _houses;
    } catch (e) {
      print('Error calculating distances: $e');
      return houses; 
    }
  }
}
