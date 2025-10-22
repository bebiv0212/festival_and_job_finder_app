class Festival {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String imageUrl;
  final bool isFree;
  final int? price;
  final List<String> tags;
  final double latitude;
  final double longitude;

  Festival({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.imageUrl,
    required this.isFree,
    this.price,
    this.tags = const [],
    required this.latitude,
    required this.longitude,
  });
}
