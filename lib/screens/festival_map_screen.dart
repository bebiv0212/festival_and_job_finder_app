import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/festival_provider.dart';

class FestivalMapScreen extends StatefulWidget {
  const FestivalMapScreen({super.key});

  @override
  State<FestivalMapScreen> createState() => _FestivalMapScreenState();
}

class _FestivalMapScreenState extends State<FestivalMapScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FestivalProvider>();
    final festivals = provider.festivals;

    Set<Marker> markers = festivals.map((f) {
      return Marker(
        markerId: MarkerId(f.id),
        position: LatLng(f.latitude, f.longitude),
        infoWindow: InfoWindow(
          title: f.name,
          snippet: f.location,
        ),
        onTap: () {
          // TODO: 상세 화면 이동
        },
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text("축제 지도")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(36.5, 127.9), // 대한민국 중심
          zoom: 6,
        ),
        markers: markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
