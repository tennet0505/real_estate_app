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
  String searchQuery = '';

  HouseBloc(this.repository, this.prefs) : super(const HouseLoadingState()) {
    on<GetHouses>(_handleGetHouses);
    on<SearchHouses>(_handleSearchHouses);
    on<ToggleFavoriteHouseEvent>(_handleToggleFavorite);
    on<GetFavoriteHouses>(_handleGetFavoriteHouses);
  }

  Future<void> _handleGetHouses(
      GetHouses event, Emitter<HouseState> emit) async {
    emit(const HouseLoadingState());

    final isConnected = await _isConnected();
    final houses = await _fetchAndCacheHouses();

    emit(HouseState(
      houses: houses,
      favoriteHouseIds: _getFavoriteIds(),
      errorMessage: !isConnected ? AppLocal.noInternetConnection.tr() : '',
    ));
  }

  void _handleSearchHouses(SearchHouses event, Emitter<HouseState> emit) {
    searchQuery = event.query.trim().toLowerCase();

    final filteredHouses = _allHouses.where((house) {
      return house.zip.toLowerCase().contains(searchQuery) ||
          house.city.toLowerCase().contains(searchQuery);
    }).toList();

    if (filteredHouses.isEmpty) {
      emit(HouseErrorState(AppLocal.noResultsFound.tr()));
    } else {
      emit(HouseState(
          houses: filteredHouses, favoriteHouseIds: _getFavoriteIds()));
    }
  }

  Future<void> _handleToggleFavorite(
      ToggleFavoriteHouseEvent event, Emitter<HouseState> emit) async {
    final updatedFavoriteIds = Set<int>.from(state.favoriteHouseIds);

    // Toggle favorite state
    if (updatedFavoriteIds.contains(event.houseId)) {
      updatedFavoriteIds.remove(event.houseId);
    } else {
      updatedFavoriteIds.add(event.houseId);
    }

    // Persist favorite IDs
    await prefs.setStringList(
      'favoriteHouseIds',
      updatedFavoriteIds.map((id) => id.toString()).toList(),
    );

    final favoriteHouses = await _getFavoriteHouses();

    List<House> filteredHouses = _allHouses;
    if (searchQuery.isNotEmpty) {
      filteredHouses = filteredHouses.where((house) {
        return house.zip.toLowerCase().contains(searchQuery) ||
            house.city.toLowerCase().contains(searchQuery);
      }).toList();
    }

    emit(HouseState(
      houses: filteredHouses,
      favoriteHouses: favoriteHouses,
      favoriteHouseIds: updatedFavoriteIds,
    ));
  }

  Future<void> _handleGetFavoriteHouses(
      GetFavoriteHouses event, Emitter<HouseState> emit) async {
    emit(HouseLoadingState());

    final favoriteHouses = await _getFavoriteHouses();

    if (favoriteHouses.isEmpty) {
      emit(HouseErrorState(AppLocal.wishlistIsEmpty.tr()));
    } else {
      emit(HouseState(
        favoriteHouses: favoriteHouses,
        favoriteHouseIds: _getFavoriteIds(),
      ));
    }
  }

  Future<List<House>> _fetchAndCacheHouses() async {
    try {
      final isConnected = await _isConnected();
      final houses = isConnected
          ? await repository.getHouses()
          : await repository.getHousesFromDB();

      final housesWithDistances = await _calculateDistances(houses);
      _allHouses
        ..clear()
        ..addAll(housesWithDistances);

      return housesWithDistances;
    } catch (_) {
      return [];
    }
  }

  Future<List<House>> _getFavoriteHouses() async {
    final favoriteIds = _getFavoriteIds();
    return _allHouses.where((house) => favoriteIds.contains(house.id)).toList();
  }

  Set<int> _getFavoriteIds() {
    final favoriteIds = prefs.getStringList('favoriteHouseIds') ?? [];
    return favoriteIds.map(int.parse).toSet();
  }

  Future<List<House>> _calculateDistances(List<House> houses) async {
    try {
      final position = await geoClient.getCurrentLocation();
      return houses.map((house) {
        house.distanceFromUser = geoClient.calculateDistance(
          position.latitude,
          position.longitude,
          house.latitude,
          house.longitude,
        );
        return house;
      }).toList();
    } catch (_) {
      return houses;
    }
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
