import 'dart:convert';
import 'dart:io';

import 'package:real_estate_app/Models/house.dart';

class ApiClient {
  final client = HttpClient();
  final String accessKey = '98bww4ezuzfePCYFxJEWyszbUXc7dxRx';

  Future<List<House>> getHouses() async {
    final json = await get('https://intern.d-tt.nl/api/house');
    final houses = json
        .map((dynamic e) => House.fromJson(e as Map<String, dynamic>))
        .toList();
    return houses;
  }

  Future<List<dynamic>> get(String uri) async {
    final url = Uri.parse(uri);
    final request = await client.getUrl(url);
    request.headers.add('Access-Key', accessKey);
    final response = await request.close();

    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as List<dynamic>;

    return json;
  }
}
