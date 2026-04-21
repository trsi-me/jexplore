import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/locale_provider.dart';
import '../models/place.dart';
import '../theme/app_theme.dart';

/// خريطة تفاعلية تعرض الأماكن مثل خرائط جوجل
class PlaceMap extends StatelessWidget {
  final List<Place> places;
  final int? selectedIndex;
  final ValueChanged<int>? onPlaceSelected;

  const PlaceMap({
    super.key,
    required this.places,
    this.selectedIndex,
    this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);
    final placesWithCoords = places.where((p) => p.hasCoordinates).toList();
    if (placesWithCoords.isEmpty) {
      return _buildPlaceholder(context, s.noCoordinates);
    }

    final center = _calculateCenter(placesWithCoords);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
            ),
            onTap: (_, __) {},
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.jexplore',
            ),
            MarkerLayer(
              markers: [
                for (var i = 0; i < placesWithCoords.length; i++)
                  Marker(
                    point: LatLng(
                      placesWithCoords[i].latitude!,
                      placesWithCoords[i].longitude!,
                    ),
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        final idx = places.indexWhere(
                            (p) => p.id == placesWithCoords[i].id);
                        if (idx >= 0 && onPlaceSelected != null) {
                          onPlaceSelected!(idx);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: (selectedIndex != null &&
                                  places[selectedIndex!].id ==
                                      placesWithCoords[i].id)
                              ? AppColors.secondaryTeal
                              : AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LatLng _calculateCenter(List<Place> list) {
    var lat = 0.0, lng = 0.0;
    for (final p in list) {
      lat += p.latitude!;
      lng += p.longitude!;
    }
    return LatLng(lat / list.length, lng / list.length);
  }

  Widget _buildPlaceholder(BuildContext context, String message) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withValues(alpha: 0.08),
            AppColors.secondaryTeal.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_rounded, size: 48, color: AppColors.primaryBlue.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
