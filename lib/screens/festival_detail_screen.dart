import 'package:flutter/material.dart';
import '../models/festival.dart';

class FestivalDetailScreen extends StatelessWidget {
  final Festival festival;

  const FestivalDetailScreen({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 정보 / 일정 / 위치 / 후기
      child: Scaffold(
        appBar: AppBar(
          title: Text(festival.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("찜한 축제에 추가되었습니다.")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("알림 설정"),
                    content: const Text("행사 시작 1일 전에 알려드릴까요?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("취소")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("알림이 설정되었습니다.")),
                            );
                          },
                          child: const Text("확인")),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // 공유 기능 (플러그인 활용 가능)
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "정보"),
              Tab(text: "일정"),
              Tab(text: "위치"),
              Tab(text: "후기"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInfoTab(),
            _buildScheduleTab(),
            _buildMapTab(),
            _buildReviewsTab(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("예매 페이지로 이동합니다.")),
              );
            },
            child: const Text("이 축제 찜하기"),
          ),
        ),
      ),
    );
  }

  /// 정보 탭
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(festival.description,
              style: const TextStyle(fontSize: 16, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 6),
              Text("${festival.startDate.toLocal()} ~ ${festival.endDate.toLocal()}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place, size: 18),
              const SizedBox(width: 6),
              Text(festival.location),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: festival.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }

  /// 일정 탭
  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text("1일차: EDM 파티"),
          subtitle: Text("18:00 ~ 23:00"),
        ),
        ListTile(
          leading: Icon(Icons.movie),
          title: Text("2일차: 영화 상영"),
          subtitle: Text("14:00 ~ 21:00"),
        ),
      ],
    );
  }

  /// 위치 탭
  Widget _buildMapTab() {
    return const Center(
      child: Text("지도 뷰 (Google Maps / Kakao Map 연동 예정)"),
    );
  }

  /// 후기 탭
  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("좋은 분위기였습니다!"),
          subtitle: Text("2024-07-16"),
        ),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("볼거리가 다양해요."),
          subtitle: Text("2024-07-17"),
        ),
      ],
    );
  }
}
