import '../database/database_helper.dart';
import '../models/place.dart';
import 'places_data_source.dart';

/// مصدر البيانات باستخدام SQLite (أندرويد، آي أو إس، سطح المكتب)
PlacesDataSource getPlacesDataSource() {
  return _SqlitePlacesDataSource();
}

class _SqlitePlacesDataSource implements PlacesDataSource {
  final DatabaseHelper _db = DatabaseHelper();

  @override
  Future<List<Place>> getPlacesByCategories(List<String> categories) async {
    return _db.getPlacesByCategories(categories);
  }
}
