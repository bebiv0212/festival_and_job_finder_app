import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/festival.dart';
import '../providers/festival_provider.dart';

class FestivalDetailScreen extends StatefulWidget {
  final Festival festival;

  const FestivalDetailScreen({super.key, required this.festival});

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreenState();
}

class _FestivalDetailScreenState extends State<FestivalDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FestivalProvider>();
    final isFav = provider.isFavorite(widget.festival.id);
    final isNotified = provider.isNotified(widget.festival.id);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ---------- 상단 배너 + 액션 버튼 ----------
            Stack(
              children: [
                Image.asset(
                  'lib/assets/images/festival_placeholder.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            // ---------- 기본 정보 ----------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.festival.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.festival.startDate.toLocal().toString().split(' ')[0]} "
                            "~ ${widget.festival.endDate.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(widget.festival.location,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: widget.festival.tags
                        .map((tag) => Chip(
                      label: Text(tag,
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey[200],
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // ---------- 액션 버튼(버블 + 텍스트) ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionBubble(
                    icon: isFav ? Icons.favorite : Icons.favorite_border,
                    label: isFav ? "찜하기":"찜완료",
                    color: Colors.red,
                    onTap: () {
                      provider.toggleFavorite(widget.festival.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav ? "찜을 해제했습니다." : "찜에 추가했습니다.",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  _buildActionBubble(
                    icon: isNotified ? Icons.notifications : Icons.notifications_none,
                    label: "알림 설정",
                    color: Colors.blue,
                    onTap: () {
                      provider.toggleNotification(widget.festival.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isNotified
                                ? "알림이 해제되었습니다."
                                : "행사 시작 1일 전에 알려드릴게요.",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  _buildActionBubble(
                    icon: Icons.directions,
                    label: "길찾기",
                    color: Colors.green,
                    onTap: () {
                      // TODO: 지도 길찾기 기능
                    },
                  ),
                ],
              ),
            ),

            // ---------- 탭 ----------
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: "정보"),
                Tab(text: "일정"),
                Tab(text: "위치"),
                Tab(text: "후기"),
              ],
            ),

            // ---------- 탭 내용 ----------
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInfoTab(),
                  _buildScheduleTab(),
                  _buildLocationTab(),
                  _buildReviewTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- 정보 탭 ----------
  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 🎵 축제 소개
        _buildInfoSection(
          icon: Icons.info_outline,
          title: "축제 소개",
          content: Text(
            widget.festival.description,
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(height: 16),

        // 💰 요금 정보
        _buildInfoSection(
          icon: Icons.attach_money,
          title: "요금 정보",
          content: Row(
            children: [
              if (widget.festival.isFree)
                const Text("무료",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
              else if (widget.festival.price != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${widget.festival.price}원",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // TODO: 예매하기 기능 연결
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 13),
                ),
                child: const Text("예매하기"),
              )
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 🏞 편의시설
        _buildInfoSection(
          icon: Icons.room_service_outlined,
          title: "편의시설",
          content: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: widget.festival.facilities.map((facility) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(facility, style: const TextStyle(fontSize: 13)),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // 📞 주최사 및 문의
        _buildInfoSection(
          icon: Icons.phone_in_talk_outlined,
          title: "주최사 및 문의",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.festival.organizer,
                  style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(widget.festival.contact,
                  style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({required String title, required Widget content, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return const Center(child: Text("일정 탭 (추후 데이터 연동)"));
  }

  Widget _buildLocationTab() {
    return const Center(child: Text("위치 탭 (구글맵 표시 예정)"));
  }

  Widget _buildReviewTab() {
    return const Center(child: Text("후기 탭 (커뮤니티 연동 예정)"));
  }
  Widget _buildActionBubble({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
