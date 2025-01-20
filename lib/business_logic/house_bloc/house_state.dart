part of 'house_bloc.dart';

class HouseState extends Equatable {
  final List<House> houses;
  final List<House> favoriteHouses;
  final Set<int> favoriteHouseIds; 
  final String errorMessage; 

  const HouseState({
    this.houses = const [],
    this.favoriteHouses = const [],
    this.favoriteHouseIds = const {},
    this.errorMessage = ''
  });

  @override
  List<Object?> get props => [houses, favoriteHouses, favoriteHouseIds];
 
  HouseState copyWith({
    List<House>? houses,
    List<House>? favoriteHouses,
    Set<int>? favoriteHouseIds,
  }) {
    return HouseState(
      houses: houses ?? this.houses,
      favoriteHouses: favoriteHouses ?? this.favoriteHouses,
      favoriteHouseIds: favoriteHouseIds ?? this.favoriteHouseIds,
    );
  }
}

class HouseLoadingState extends HouseState {
  const HouseLoadingState();
}

class HouseErrorState extends HouseState {
  final String message;
  const HouseErrorState(this.message);
}

class HouseRemovedFromFavoriteState extends HouseState {
  final String? removedHouseZip;
  const HouseRemovedFromFavoriteState(this.removedHouseZip);
}
