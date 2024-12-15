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