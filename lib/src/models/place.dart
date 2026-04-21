/// نموذج يمثل مكاناً سياحياً في جدة
class Place {
  final int id;
  final String name;
  final String category;
  final String? description;
  final String? address;
  final String? openingHours;
  final String? tips;
  final double? latitude;
  final double? longitude;
  final double? distanceToNext;

  Place({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.address,
    this.openingHours,
    this.tips,
    this.latitude,
    this.longitude,
    this.distanceToNext,
  });

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as int,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String?,
      address: map['address'] as String?,
      openingHours: map['opening_hours'] as String?,
      tips: map['tips'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      distanceToNext: (map['distance_to_next'] as num?)?.toDouble(),
    );
  }

  Place copyWith({double? distanceToNext}) {
    return Place(
      id: id,
      name: name,
      category: category,
      description: description,
      address: address,
      openingHours: openingHours,
      tips: tips,
      latitude: latitude,
      longitude: longitude,
      distanceToNext: distanceToNext ?? this.distanceToNext,
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}
