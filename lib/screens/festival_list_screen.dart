import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/festival_provider.dart';
import '../widgets/festival_card.dart';
import 'festival_detail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FestivalListScreen extends StatefulWidget {
  const FestivalListScreen({super.key});

  @override
  State<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends State<FestivalListScreen> {
  bool showMap = false;
  final TextEditingController _searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    // 👉 더미 데이터 로드
    Future.microtask(() =>
        Provider.of<FestivalProvider>(context, listen: false).loadDummyFestivals()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FestivalProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Scaffold(
        body: Center(child: Text('에러 발생: ${provider.error}')),
      );
    }

    final festivals = provider.festivals;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ---------- 상단 검색창 + 필터 ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: "축제명 · 지역 검색",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        // TODO: 검색 기능
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: 필터 바텀시트
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => const SizedBox(
                          height: 200,
                          child: Center(child: Text("필터 옵션 자리")),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ---------- 리스트/지도 전환 버튼 ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text("리스트"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showMap ? Colors.grey[300] : Colors.blue,
                      foregroundColor: showMap ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        showMap = false;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text("지도"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showMap ? Colors.blue : Colors.grey[300],
                      foregroundColor: showMap ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        showMap = true;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------- 본문: 리스트 or 지도 ----------
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(child: Text("에러: ${provider.error}"))
                  : showMap
                  ? _buildMapView(festivals)
                  : _buildListView(festivals),
            ),
          ],
        ),
      ),
    );
  }

  // 리스트 뷰
  Widget _buildListView(festivals) {
    return ListView.builder(
      itemCount: festivals.length,
      itemBuilder: (ctx, i) => FestivalCard(
        festival: festivals[i],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FestivalDetailScreen(festival: festivals[i]),
            ),
          );
        },
        onNavigate: () {},
        onShare: () {},
      ),
    );
  }

  // 지도 뷰 (임시)
  Widget _buildMapView(festivals) {
    return const Center(
      child: Text("지도 뷰 자리 (GoogleMap 예정)"),
    );
  }
}



/* api적용 후
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/festival_provider.dart';
import '../widgets/festival_card.dart';
import 'festival_detail_screen.dart';

class FestivalListScreen extends StatefulWidget {
  const FestivalListScreen({super.key});

  @override
  State<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends State<FestivalListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FestivalProvider>(context, listen: false).loadFestivals());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FestivalProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text("Error: ${provider.error}"));
    }

    final festivals = provider.festivals;

    return Scaffold(
      appBar: AppBar(title: const Text("축제 리스트")),
      body: ListView.builder(
        itemCount: festivals.length,
        itemBuilder: (ctx, i) => FestivalCard(
          festival: festivals[i],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FestivalDetailScreen(festival: festivals[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/