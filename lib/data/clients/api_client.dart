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
      return json;
    } catch (e) {
      throw FormatException('Error parsing JSON: $e');
    }
  }
}

enum HttpRequestMethod { get, post, put, delete }

class HttpClientApi {
  late HttpClient client;

  HttpClientApi() {
    client = HttpClient();
  }

  Future<Map<String, dynamic>> requestAPI(
      HttpRequestMethod method, String uri, Map<String, dynamic>? body) async {
    final url = Uri.parse(uri);

    try {
      HttpClientRequest request;
      switch (method) {
        case HttpRequestMethod.get:
          request = await client.getUrl(url);
          break;
        case HttpRequestMethod.post:
          request = await client.postUrl(url);
          if (body != null) {
            request.headers.contentType = ContentType.json;
            request.write(jsonEncode(body));
          }
          break;
        case HttpRequestMethod.put:
          request = await client.putUrl(url);
          if (body != null) {
            request.headers.contentType = ContentType.json;
            request.write(jsonEncode(body));
          }
          break;
        case HttpRequestMethod.delete:
          request = await client.deleteUrl(url);
          if (body != null) {
            request.headers.contentType = ContentType.json;
            request.write(jsonEncode(body));
          }
          break;
      }

      // Sending the request and awaiting the response
      final response = await request.close();

      // Reading and decoding the response
      final responseBody = await response.transform(utf8.decoder).join();
      final decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedResponse;
      } else {
        throw HttpException(
          'Request failed with status: ${response.statusCode}. Body: $responseBody',
        );
      }
    } catch (e) {
      throw Exception('An error occurred during the HTTP request: $e');
    }
  }

  void close() {
    client.close();
  }
}

class Httpclient {
  late HttpClient client;
  Httpclient() {
    client = HttpClient();
  }
  Future<Map<String, dynamic>> requestApi(HttpRequestMethod method,
      String urlString, Map<String, dynamic>? body) async {
    final url = Uri.parse(urlString);

    try {
      HttpClientRequest request;
      switch (method) {
        case HttpRequestMethod.get:
          request = await client.getUrl(url);

        case HttpRequestMethod.post:
          request = await client.postUrl(url);
          request.headers.contentType = ContentType.json;
          request.write(jsonEncode(body));

        case HttpRequestMethod.put:
          request = await client.putUrl(url);
          request.headers.contentType = ContentType.json;
          request.write(jsonEncode(body));

        case HttpRequestMethod.delete:
          request = await client.deleteUrl(url);
          request.headers.contentType = ContentType.json;
          request.write(jsonEncode(body));
      }
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException("Status code: $response.statusCode");
      }

      final responseBody = await response.transform(utf8.decoder).join();
      final decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

      return decodedResponse;
    } catch (error) {
      throw FormatException('Error: $error');
    }
  }
}
