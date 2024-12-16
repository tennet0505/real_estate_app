import 'package:hive/hive.dart';
import 'package:real_estate_app/data/clients/api_client.dart';
import 'package:real_estate_app/data/models/house.dart';

class HouseRepository {
  final apiClient = ApiClient();
  static const _houseBoxName = 'housesBox';

  Future<List<House>> getHouses() async {
    final houses = await apiClient.getHouses();
    houses.sort((a, b) => a.price.compareTo(b.price));
    final housesFromDB = await getHousesFromDB();
    if (housesFromDB.isEmpty || housesFromDB.length != houses.length) {
      saveHouses(houses);
    }
    return houses;
  }

  Future<void> saveHouses(List<House> houses) async {
    final box = await Hive.openBox<House>(_houseBoxName);
    await box.clear(); // Clear existing data (optional)
    await box.addAll(houses); // Save the list of houses
  }

  Future<List<House>> getHousesFromDB() async {
    final box = await Hive.openBox<House>(_houseBoxName);
    return box.values.toList(); // Return the list of houses
  }
}
