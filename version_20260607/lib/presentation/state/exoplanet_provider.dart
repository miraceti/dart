import '../data/nasa_api.dart';

class ExoplanetProvider {
  List data = [];
  bool loading = false;

  Future<void> load({int limit = 500}) async {
    loading = true;

    try {
      data = await NasaApi.fetchExoplanets(limit: limit);
    } catch (e) {
      print("NASA ERROR: $e");
      data = [];
    }

    loading = false;
  }
}