import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/festival.dart';
import '../providers/festival_provider.dart';

class FestivalCard extends StatelessWidget {
  final Festival festival;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onNavigate;

  const FestivalCard({
    super.key,
    required this.festival,
    required this.onTap,
    this.onShare,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FestivalProvider>();
    final isFav = provider.isFavorite(festival.id);

    return Card(
      margin: const EdgeInsets.all(12),
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- 상단 이미지 + 찜 + 가격 ----------
            Stack(
              children: [
                Image.asset(
                  'lib/assets/images/festival_placeholder.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // 찜 버튼 (오른쪽 상단)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(festival.id);
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
                  ),
                ),

                // ✅ 가격 박스 (왼쪽 하단)
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: festival.isFree ? Colors.green[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      festival.isFree ? "무료" : "${festival.price ?? 0}원",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: festival.isFree ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ---------- 메인 정보 ----------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    festival.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(festival.description,
                    style: TextStyle(color: Colors.grey),

                  ),

                  const SizedBox(height: 6),

                  // 날짜
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${festival.startDate.toLocal().toString().split(' ')[0]} "
                            "~ ${festival.endDate.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 위치
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          festival.location,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 태그칩
                  Wrap(
                    spacing: 6,
                    children: festival.tags.map((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey[200],
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 8),

                  // ✅ 액션 버튼: 공유, 길찾기 (왼쪽 정렬)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.directions, color: Colors.grey),
                        onPressed: onNavigate,
                      ),
                      Text('길찾기'),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.grey),
                        onPressed: onShare,
                      ),
                      Text('공유'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
