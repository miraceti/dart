import 'package:http/http.dart' as http;
import 'dart:convert';

class NasaApi {
  static const String baseUrl =
      "https://exoplanetarchive.ipac.caltech.edu/TAP/sync";

  static Future<List<dynamic>> fetchExoplanets() async {
    final uri = Uri.parse(
      "$baseUrl?query=select+top+500+pl_name,"
      "MAX(pl_bmasse)+as+pl_bmasse,"
      "MAX(pl_rade)+as+pl_rade,"
      "MAX(disc_year)+as+disc_year,"
      "MAX(sy_dist)+as+sy_dist,"
      "MAX(pl_eqt)+as+pl_eqt"
      "+from+pscomppars+where+sy_dist+>1.0+and+sy_dist+<50.0+group+by+pl_name+order+by+sy_dist&format=json",
    );

    final res = await http.get(uri).timeout(
      const Duration(seconds: 20),
    );

    if (res.statusCode != 200) {
      throw Exception("NASA API error: ${res.statusCode}");
    }

    return jsonDecode(res.body);
  }

  static Future<int> fetchExoplanetCount() async {
    final uri = Uri.parse(
      "$baseUrl?query=select+count(distinct + pl_name)+as+n+from+ps&format=json",
    );

    final res = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (res.statusCode != 200) {
      throw Exception("NASA COUNT API error");
    }

    final json = jsonDecode(res.body);

    return json[0]['n'] ?? 0;
  }

  static Future<List> fetchDiscoveryMethods() async {
    final uri = Uri.parse(
      "$baseUrl?query=select+discoverymethod,count(distinct+pl_name)+as+n+from+ps+group+by+discoverymethod+order+by+n+desc&format=json",
    );

    final res = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (res.statusCode != 200) {
      throw Exception("NASA METHOD API error");
    }

    return jsonDecode(res.body);
  }

static Future<List> fetchDiscoveryByYear() async {
  final uri = Uri.parse(
    "$baseUrl?query=select+disc_year,count(distinct+pl_name)+as+n"
    "+from+ps+group+by+disc_year+order+by+disc_year+asc&format=json",
  );

  final res = await http.get(uri);

  if (res.statusCode != 200) {
    throw Exception("NASA YEAR API error");
  }

  return jsonDecode(res.body);
}


static Future<List<dynamic>> fetchClosestPlanets() async {
    final uri = Uri.parse(
    "$baseUrl?query=select+distinct+top+5000+pl_name,sy_dist"
    "+from+pscomppars+where+sy_dist+>1.0+and+sy_dist+<30.0+order+by+sy_dist+asc&format=json",
  );

  //final res = await http.get(uri);
  final res = await http.get(uri).timeout(
    const Duration(seconds: 10),
  );

  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception("NASA CLOSEST API error: ${res.statusCode}");
  }

  final data = jsonDecode(res.body);

  print("TOTAL FROM API: ${data.length}");

  // 👇 IMPORTANT: tu limites côté Flutter
  return (data as List).take(200).toList();

  //return jsonDecode(res.body);
  }

}

