import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/festival.dart';

class FestivalApiService {
  final String _baseUrl =
      "http://api.data.go.kr/openapi/cltur-fstvl-std"; // 전국문화축제표준데이터
  final String _serviceKey = "YOUR_SERVICE_KEY"; // 발급받은 인증키

  Future<List<Festival>> fetchFestivals({int page = 1, int size = 50}) async {
    final uri = Uri.parse(
        "$_baseUrl?serviceKey=$_serviceKey&type=json&s_page=$page&s_list=$size");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List records = jsonData['records'] ?? [];

      return records.map((json) {
        return Festival(
          id: json['opar']?.toString() ?? '',
          name: json['fstvlNm'] ?? '',
          description: json['fstvlCo'] ?? '',
          startDate: DateTime.tryParse(json['fstvlStartDate'] ?? '') ??
              DateTime.now(),
          endDate: DateTime.tryParse(json['fstvlEndDate'] ?? '') ??
              DateTime.now(),
          location: json['rdnmadr'] ?? '',
          imageUrl: json['fstvlImage'] ?? 'https://picsum.photos/400/200',
          isFree: (json['entrncInfo'] ?? '').contains("무료"),
          price: null,
          tags: [],
          latitude: double.tryParse(json['latitude'] ?? '') ?? 0.0,
          longitude: double.tryParse(json['longitude'] ?? '') ?? 0.0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load festivals');
    }
  }
}
