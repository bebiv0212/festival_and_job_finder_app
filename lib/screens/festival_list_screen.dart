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
      appBar: AppBar(title: const Text("축제 리스트 (더미 데이터)")),
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