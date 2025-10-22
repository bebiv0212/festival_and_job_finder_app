import 'package:flutter/material.dart';
import '../models/festival.dart';
import '../services/festival_api_service.dart';

class FestivalProvider with ChangeNotifier {
  List<Festival> _festivals = [];
  bool _isLoading = false;
  String? _error;

  List<Festival> get festivals => _festivals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FestivalApiService _apiService = FestivalApiService();
  Future<void> loadFestivals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await _apiService.fetchFestivals();
      _festivals = results;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void loadDummyFestivals() {
    _festivals = [
      Festival(
        id: '1',
        name: '한강 여름 음악 페스티벌',
        description: '한강에서 열리는 EDM 음악 축제입니다. 다양한 장르의 뮤지션들이 참여합니다.',
        startDate: DateTime(2024, 7, 15),
        endDate: DateTime(2024, 7, 17),
        location: '서울 여의도 한강공원',
        imageUrl: 'https://picsum.photos/id/1015/400/200',
        isFree: false,
        price: 15000,
        tags: ['EDM', '야외', '음악'],
        latitude: 37.528,
        longitude: 126.932,
      ),
      Festival(
        id: '2',
        name: '부산 국제 영화제',
        description: '아시아 최대 규모의 영화제. 다양한 나라의 영화가 상영됩니다.',
        startDate: DateTime(2024, 10, 3),
        endDate: DateTime(2024, 10, 12),
        location: '부산 해운대 영화의전당',
        imageUrl: 'https://picsum.photos/id/1021/400/200',
        isFree: true,
        price: null,
        tags: ['영화', '문화'],
        latitude: 35.168,
        longitude: 129.137,
      ),
      Festival(
        id: '3',
        name: '전주 한옥마을 전통문화축제',
        description: '전통 공연, 먹거리, 체험 프로그램이 가득한 축제.',
        startDate: DateTime(2024, 9, 20),
        endDate: DateTime(2024, 9, 25),
        location: '전주 한옥마을',
        imageUrl: 'https://picsum.photos/id/1035/400/200',
        isFree: true,
        price: null,
        tags: ['전통', '문화', '체험'],
        latitude: 35.815,
        longitude: 127.149,
      ),
    ];

    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

/*
api 넣고 활성화
import 'package:flutter/material.dart';
import '../models/festival.dart';
import '../services/festival_api_service.dart';

class FestivalProvider with ChangeNotifier {
  List<Festival> _festivals = [];
  bool _isLoading = false;
  String? _error;

  List<Festival> get festivals => _festivals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FestivalApiService _apiService = FestivalApiService();

  Future<void> loadFestivals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await _apiService.fetchFestivals();
      _festivals = results;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
*/