import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/festival.dart';
import 'festival_detail_screen.dart';

class FestivalMapScreen extends StatelessWidget {
  final List<Festival> festivals;

  const FestivalMapScreen({super.key, required this.festivals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("축제 지도")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(festivals.first.latitude, festivals.first.longitude),
          zoom: 10,
        ),
        markers: festivals.map((f) {
          return Marker(
            markerId: MarkerId(f.id),
            position: LatLng(f.latitude, f.longitude),
            infoWindow: InfoWindow(
              title: f.name,
              snippet: f.location,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FestivalDetailScreen(festival: f),
                  ),
                );
              },
            ),
          );
        }).toSet(),
      ),
    );
  }
}
