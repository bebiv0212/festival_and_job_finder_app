import 'package:flutter/material.dart';
import '../models/festival.dart';

class FestivalCard extends StatelessWidget {
  final Festival festival;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final VoidCallback? onNavigate;

  const FestivalCard({
    super.key,
    required this.festival,
    required this.onTap,
    this.onFavorite,
    this.onShare,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
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
            // ---------- 상단 이미지 + 찜 버튼 ----------
            Stack(
              children: [
                Image.asset(
                  'lib/assets/images/festival_placeholder.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                /*
            Image.network(
              festival.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),*/
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: onFavorite,
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
                  // 축제명 + 가격박스
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          festival.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (festival.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("무료",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        )
                      else if (festival.price != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text("${festival.price}원",
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                    ],
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
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
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

                  // 액션 버튼: 공유, 길찾기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.grey),
                        onPressed: onShare,
                      ),
                      IconButton(
                        icon: const Icon(Icons.directions, color: Colors.grey),
                        onPressed: onNavigate,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}