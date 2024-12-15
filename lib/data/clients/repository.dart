import 'package:real_estate_app/data/clients/api_client.dart';
import 'package:real_estate_app/data/models/house.dart';

class HouseRepository {
  final apiClient = ApiClient();

  Future<List<House>> getHouses() async {
    final houses = await apiClient.getHouses();
     houses.sort((a, b) => a.price.compareTo(b.price));
    return houses;
  }
}
