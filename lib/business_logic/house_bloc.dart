import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:real_estate_app/data/clients/geo_client.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
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
        emit(HouseErrorState(AppLocal.noInternetConnection.tr()));
      } 
      emit(HouseState(houses: houses,
      favoriteHouseIds: _getFavoriteIds(),
      errorMessage: (!isConnected) ? AppLocal.noInternetConnection.tr() : '' ));
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
          emit(HouseErrorState(
              AppLocal.noResultsFound.tr()));
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
        emit(HouseErrorState(AppLocal.wishlistIsEmpty.tr()));
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
          emit(HouseErrorState(AppLocal.wishlistIsEmpty.tr()));
        } else {
          emit(HouseState(
              favoriteHouses: favoriteHouses,
              favoriteHouseIds: _getFavoriteIds()));
        }
      } catch (e) {
        emit(HouseErrorState(AppLocal.somethingWentWrongPleaseAgain.tr()));
      }
    });
  }

  /// Fetches the list of houses from either the online repository or the local database,
  /// based on the connectivity status. Updates the list with calculated distances.
  Future<List<House>> _getHouses() async {
    final isConnected = await _isConnected();
    try {
      if (!isConnected) {
        // Fetch houses from the local database if offline.
        final houses = await _getHousesFromDB();
        final housesWithDistances = await calculateDistances(houses);
        _allHouses.clear();
        _allHouses.addAll(houses); // Cache the fetched houses.
        return housesWithDistances;
      } else {
        // Fetch houses from the online repository if online.
        final houses = await repository.getHouses();
        final housesWithDistances = await calculateDistances(houses);
        _allHouses.clear();
        _allHouses.addAll(houses); // Cache the fetched houses.
        return housesWithDistances;
      }
    } catch (e) {
      return []; 
    }
  }

  /// Fetches the list of favorite houses based on the IDs stored in SharedPreferences.
  Future<List<House>> _getFavoriteHouses() async {
    final houses = await _getHouses(); 
    final housesWithDistances = await calculateDistances(houses);
    final favoriteIds = _getFavoriteIds(); 
    // Filter houses by favorite IDs.
    final favoriteHouses = housesWithDistances
        .where((house) => favoriteIds.contains(house.id))
        .toList();
    return favoriteHouses;
  }

  /// Fetches the list of houses from the local database.
  Future<List<House>> _getHousesFromDB() async {
    try {
      final houses = await repository.getHousesFromDB();
      final housesWithDistances = await calculateDistances(houses);
      return housesWithDistances;
    } catch (e) {
      return []; 
    }
  }

  /// Retrieves the set of favorite house IDs from SharedPreferences.
  Set<int> _getFavoriteIds() {
    final favoriteIds = prefs.getStringList('favoriteHouseIds') ?? [];
    return favoriteIds.map((id) => int.parse(id)).toSet();
  }

  /// Calculates the distances from the user's current location to each house.
  /// Updates the `distanceFromUser` property in each house.
  Future<List<House>> calculateDistances(List<House> houses) async {
    try {
      // Fetch the user's current location.
      final position = await geoClient.getCurrentLocation();
      final userLat = position.latitude;
      final userLon = position.longitude;

      // Calculate distances for each house.
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

  /// Checks the connectivity status by using `Connectivity` and performs a network ping
  /// to verify internet access.
  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; 
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
    return false; // Default to false if check fails.
  }
}
