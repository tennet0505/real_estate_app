part of 'house_bloc.dart';

class HouseState extends Equatable {
  final List<House> houses;
  const HouseState({this.houses = const []});

  @override
  List<Object?> get props => [houses];

  HouseState copyWith({List<House>? houses}) {
    return HouseState(houses: houses ?? this.houses);
  }
}

class HouseLoadingState extends HouseState {
  const HouseLoadingState();
}

class HouseErrorState extends HouseState {
  final String message;
  const HouseErrorState(this.message);
}

