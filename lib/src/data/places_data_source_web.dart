import '../models/place.dart';
import 'embedded_places_data.dart';
import 'places_data_source.dart';

/// مصدر البيانات المضمّنة للويب (بدون SQLite - فرونت اند فقط)
PlacesDataSource getPlacesDataSource() {
  return _EmbeddedPlacesDataSource();
}

class _EmbeddedPlacesDataSource implements PlacesDataSource {
  @override
  Future<List<Place>> getPlacesByCategories(List<String> categories) async {
    if (categories.isEmpty) return [];
    final categorySet = categories.toSet();
    return embeddedPlaces
        .where((p) => categorySet.contains(p.category))
        .toList();
  }
}
