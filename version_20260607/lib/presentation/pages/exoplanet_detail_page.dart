import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExoplanetDetailPage extends StatelessWidget {
  final Map planet;

  const ExoplanetDetailPage({super.key, required this.planet});

  double get habitabilityScore {
    final temp = planet['pl_eqt'];
    final radius = planet['pl_rade'];

    if (temp == null || radius == null) return 0;

    double score = 0;

    // 🌡 température idéale ~ 288K
    score += (1 - ((temp - 288).abs() / 288)).clamp(0, 1);

    // 📏 rayon proche de la Terre
    score += (1 - ((radius - 1).abs())).clamp(0, 1);

    return (score / 2) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(planet['pl_name'] ?? ''),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🪐 HERO ICON
            Center(
              child: GestureDetector(
                        onTap: openNasaPage,
                        child: Hero(
                          tag: planet['pl_name'],
                          child: const Icon(
                            Icons.public,
                            size: 90,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
            ),

            const SizedBox(height: 20),

            // 🪐 NAME
            Center(
              child: Text(
                planet['pl_name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🌍 HABITABILITY SCORE
            _card(
              "🌍 Habitabilité",
              "${habitabilityScore.toStringAsFixed(1)} %",
              color: _scoreColor(),
            ),

            // 📊 DATA
            _card("🌍 Masse", "${planet['pl_bmasse']}"),
            _card("📏 Rayon", "${planet['pl_rade']}"),
            _card("📡 Distance", "${planet['sy_dist']} pc"),
            _card("🌡 Température", "${planet['pl_eqt']} K"),
            _card("🗓 Découverte", "${planet['disc_year']}"),
            _card("🔭 Méthode", "${planet['discoverymethod']}"),

            const SizedBox(height: 20),

            // 🌍 COMPARAISON TERRE
            const Text(
              "Comparaison avec la Terre",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _compare("Rayon", planet['pl_rade'], 1),
            _compare("Température", planet['pl_eqt'], 288),

          ],
        ),
      ),
    );
  }

  Future<void> openNasaPage() async {
    final name = planet['pl_name'];

    if (name == null) return;

    final encoded = Uri.encodeComponent(name);
    final anchor = name.replaceAll(" ", "-");

    final url =
        "https://exoplanetarchive.ipac.caltech.edu/overview/$encoded#planet_${anchor}_collapsible";

    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
    
  }

  // 🎨 CARD
  Widget _card(String label, String value, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 🌍 COMPARAISON
  Widget _compare(String label, dynamic value, double earthValue) {
    if (value == null) return const SizedBox();

    double ratio = value / earthValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: (ratio / 3).clamp(0, 1),
              backgroundColor: Colors.grey[800],
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${ratio.toStringAsFixed(2)}x",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // 🎯 SCORE COLOR
  Color _scoreColor() {
    if (habitabilityScore > 70) return Colors.green;
    if (habitabilityScore > 40) return Colors.orange;
    return Colors.red;
  }
}