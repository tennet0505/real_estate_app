import 'dart:convert';
import 'dart:io';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/constants.dart';

class ApiClient {
  final HttpClient client = HttpClient();

  Future<List<House>> getHouses() async {
    final json = await _get('${Constants.mainUrl}/api/house');
    final houses = json
        .map((dynamic e) => House.fromJson(e as Map<String, dynamic>))
        .toList();
    return houses;
  }

  Future<List<dynamic>> _get(String uri) async {
    final url = Uri.parse(uri);
    final request = await client.getUrl(url);
    request.headers.add('Access-Key', Constants.accessKey);

    final response = await request.close();

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }

    try {
      final jsonStrings = await response.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString);
      if (json is! List<dynamic>) {
        throw FormatException('Invalid JSON format');
      }
      return json as List<dynamic>;
    } catch (e) {
      throw FormatException('Error parsing JSON: $e');
    }
  }
}

