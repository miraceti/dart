import 'package:http/http.dart' as http;
import 'dart:convert';

class NasaApi {
  static const String baseUrl =
      "https://exoplanetarchive.ipac.caltech.edu/TAP/sync";

  static Future<List<dynamic>> fetchExoplanets() async {
    final uri = Uri.parse(
      "$baseUrl?query=select+distinct+top+500+pl_name,pl_bmasse,pl_rade,disc_year,sy_dist,pl_eqt"
      "+from+ps+order+by+sy_dist&format=json",
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

}