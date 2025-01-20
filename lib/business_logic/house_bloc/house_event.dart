part of 'house_bloc.dart';

abstract class HouseEvent {
  const HouseEvent();
}

class GetHouses extends HouseEvent {
  const GetHouses();
}

class SearchHouses extends HouseEvent {
  final String query;
  const SearchHouses(this.query);
}

class GetFavoriteHouses extends HouseEvent {
  const GetFavoriteHouses();
}

class ToggleFavoriteHouseEvent extends HouseEvent {
  final House house;
  ToggleFavoriteHouseEvent(this.house);
}

class RefreshHouses extends HouseEvent {
  const RefreshHouses();
}

class RemovedFromFavorite extends HouseEvent {
  const RemovedFromFavorite();
}

abstract class Event {
  const Event();
}
