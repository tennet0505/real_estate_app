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
  final GeoClient geoClient = GeoClient();
  final List<House> _allHouses = [];
  final SharedPreferences prefs;
  String searchQuery = '';
  Set<int> _favoriteIds = {}; // Cached favorite IDs
  bool _isDataLoaded = false; // Flag to check if data is already loaded
  String? _removedHouseZip;

  HouseBloc(this.repository, this.prefs) : super(const HouseLoadingState()) {
    on<GetHouses>(_handleGetHouses);
    on<SearchHouses>(_handleSearchHouses);
    on<ToggleFavoriteHouseEvent>(_handleToggleFavorite);
    on<GetFavoriteHouses>(_handleGetFavoriteHouses);
    on<RefreshHouses>(_handleRefreshHouses); // Added event for pull-to-refresh
    on<RemovedFromFavorite>(_handleRemovedFromFavoriteHouses);
  }

  // Method to refresh the favoriteIds cache from SharedPreferences
  Future<void> _refreshFavoriteIds() async {
    final favoriteIds = prefs.getStringList('favoriteHouseIds') ?? [];
    _favoriteIds = favoriteIds.map(int.parse).toSet();
  }

  Future<void> _handleGetHouses(
      GetHouses event, Emitter<HouseState> emit) async {
    if (_isDataLoaded) {
      // If data is already loaded, just return the existing houses
      final houses = _allHouses;
      emit(HouseState(
        houses: houses,
        favoriteHouseIds: _favoriteIds,
      ));
      return;
    }

    emit(const HouseLoadingState());

    final isConnected = await _isConnected();
    final houses = await _fetchAndCacheHouses();

    // Refresh favoriteIds once when houses are fetched
    await _refreshFavoriteIds();

    _isDataLoaded = true; // Set the flag to true after data is loaded

    emit(HouseState(
      houses: houses,
      favoriteHouseIds: _favoriteIds,
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
        houses: filteredHouses,
        favoriteHouseIds: _favoriteIds, // Use cached favorite IDs
      ));
    }
  }

  Future<void> _handleToggleFavorite(
      ToggleFavoriteHouseEvent event, Emitter<HouseState> emit) async {
    // Toggle favorite state
    if (_favoriteIds.contains(event.house.id)) {
      _favoriteIds.remove(event.house.id);
      _removedHouseZip = event.house.zip;
    } else {
      _favoriteIds.add(event.house.id);
    }

    // Persist favorite IDs
    await prefs.setStringList(
      'favoriteHouseIds',
      _favoriteIds.map((id) => id.toString()).toList(),
    );

    final favoriteHouses = await _getFavoriteHouses();

    List<House> filteredHouses = _allHouses;
    if (searchQuery.isNotEmpty) {
      filteredHouses = filteredHouses.where((house) {
        return house.zip.toLowerCase().contains(searchQuery) ||
            house.city.toLowerCase().contains(searchQuery);
      }).toList();
    }

    if (favoriteHouses.isEmpty) {
      emit(HouseErrorState(AppLocal.wishlistIsEmpty.tr()));
    } else {
      emit(HouseState(
        houses: filteredHouses,
        favoriteHouses: favoriteHouses,
        favoriteHouseIds: _favoriteIds, // Use cached favorite IDs
      ));
    }
  }

  Future<void> _handleRemovedFromFavoriteHouses(
      RemovedFromFavorite event, Emitter<HouseState> emit) async {
    if (_removedHouseZip != null) {
      emit(HouseRemovedFromFavoriteState(_removedHouseZip));
    }
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
        favoriteHouseIds: _favoriteIds, // Use cached favorite IDs
      ));
    }
  }

  // Handle refresh event (pull-to-refresh)
  Future<void> _handleRefreshHouses(
      RefreshHouses event, Emitter<HouseState> emit) async {
    emit(const HouseLoadingState());

    _isDataLoaded = false; // Reset the flag so that fresh data will be loaded
    final houses = await _fetchAndCacheHouses();

    // Refresh favoriteIds once when houses are fetched
    await _refreshFavoriteIds();

    emit(HouseState(
      houses: houses,
      favoriteHouseIds: _favoriteIds,
    ));
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
    return _allHouses
        .where((house) => _favoriteIds.contains(house.id))
        .toList();
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
