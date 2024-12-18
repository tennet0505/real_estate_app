import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_estate_app/data/clients/geo_client.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'house_event.dart';
part 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final HouseRepository repository;
  final List<House> _allHouses = [];
  final GeoClient geoClient = GeoClient();
  final SharedPreferences prefs;

  HouseBloc(this.repository, this.prefs) : super(const HouseLoadingState()) {
    on<GetHouses>((event, emit) async {
      emit(const HouseLoadingState());

      final isConnected = await _isConnected();
      final houses = await _getHouses();
      if (!isConnected) {
        emit(const HouseErrorState('No internet connection'));
      } 
      emit(HouseState(houses: houses,
      favoriteHouseIds: _getFavoriteIds(),
      errorMessage: (!isConnected) ? 'No internet connection' : '' ));
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
        if (filteredHouses.isEmpty) {
          emit(const HouseErrorState(
              'No results found \n Perhaps try another search?'));
        } else {
          emit(HouseState(houses: filteredHouses));
        }
      }
    });

    on<ToggleFavoriteHouseEvent>((event, emit) async {
      final updatedFavoriteIds = Set<int>.from(state.favoriteHouseIds);

      if (updatedFavoriteIds.contains(event.houseId)) {
        // Remove from favorites
        updatedFavoriteIds.remove(event.houseId);
      } else {
        // Add to favorites
        updatedFavoriteIds.add(event.houseId);
      }

      // Persist the favorite house IDs in SharedPreferences
      await prefs.setStringList(
        'favoriteHouseIds',
        updatedFavoriteIds.map((id) => id.toString()).toList(),
      );
      final favoriteHouses = await _getFavoriteHouses();
      final houses = await _getHouses();
      if (favoriteHouses.isEmpty) {
        emit(HouseErrorState('Wishlist is empty'));
      } else {
        emit(HouseState(
          houses: houses,
          favoriteHouses: favoriteHouses,
          favoriteHouseIds: updatedFavoriteIds,
        ));
      }
    });

    on<GetFavoriteHouses>((event, emit) async {
      emit(HouseLoadingState());
      try {
        final favoriteHouses = await _getFavoriteHouses();
        if (favoriteHouses.isEmpty) {
          emit(HouseErrorState('Wishlist is empty'));
        } else {
          emit(HouseState(
              favoriteHouses: favoriteHouses,
              favoriteHouseIds: _getFavoriteIds()));
        }
      } catch (e) {
        emit(HouseErrorState('Something went wrong. Please try again later.'));
      }
    });
  }

  Future<List<House>> _getHouses() async {
    final isConnected = await _isConnected();
    try {
      if (!isConnected) {
        final houses = await _getHousesFromDB();
        final housesWithDistances = await calculateDistances(houses);
        _allHouses.clear();
        _allHouses.addAll(houses);
        return housesWithDistances;
      } else {
        final houses = await repository.getHouses();
        final housesWithDistances = await calculateDistances(houses);
        _allHouses.clear();
        _allHouses.addAll(houses);
        return housesWithDistances;
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<House>> _getFavoriteHouses() async {
    final houses = await _getHouses();
    final housesWithDistances = await calculateDistances(houses);
    final favoriteIds = _getFavoriteIds();
    final favoriteHouses = housesWithDistances
        .where((house) => favoriteIds.contains(house.id))
        .toList();
    return favoriteHouses;
  }

  Future<List<House>> _getHousesFromDB() async {
    try {
      final houses = await repository.getHousesFromDB();
      final housesWithDistances = await calculateDistances(houses);
      return housesWithDistances;
    } catch (e) {
      return [];
    }
  }

  Set<int> _getFavoriteIds() {
    final favoriteIds = prefs.getStringList('favoriteHouseIds') ?? [];
    return favoriteIds.map((id) => int.parse(id)).toSet();
  }

  Future<List<House>> calculateDistances(List<House> houses) async {
    try {
      final position = await geoClient.getCurrentLocation();
      final userLat = position.latitude;
      final userLon = position.longitude;

      final housesUpdated = houses.map((house) {
        final distance = geoClient.calculateDistance(
          userLat,
          userLon,
          house.latitude,
          house.longitude,
        );
        house.distanceFromUser = distance;
        return house;
      }).toList();
      return housesUpdated;
    } catch (e) {
      return houses;
    }
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No connection at all.
    }
    // Perform an actual internet check (ping).
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection is active.
      }
    } on SocketException catch (_) {
      return false; // Internet is not reachable.
    }
    return false;
  }
}
