import 'dart:convert';
import 'dart:io';

import 'package:real_estate_app/Models/house.dart';
import 'package:real_estate_app/helpers/constants.dart';

class ApiClient {
  final client = HttpClient();

  Future<List<House>> getHouses() async {
    final json = await get('${Constants.mainUrl}/api/house');
    final houses = json
        .map((dynamic e) => House.fromJson(e as Map<String, dynamic>))
        .toList();
    return houses;
  }

  Future<List<dynamic>> get(String uri) async {
    final url = Uri.parse(uri);
    final request = await client.getUrl(url);
    request.headers.add('Access-Key', Constants.accessKey);
    final response = await request.close();

    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as List<dynamic>;

    return json;
  }
}
