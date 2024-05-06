import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.coincap.io/v2/assets';

  Future<List<dynamic>> fetchCryptos({int start = 0}) async {
    try {
      Response response = await _dio.get(_baseUrl, queryParameters: {
        'offset': start,
        'limit': 15,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
