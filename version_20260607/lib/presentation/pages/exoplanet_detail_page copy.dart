import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ExoplanetDetailPage extends StatelessWidget {
  final Map planet;

  const ExoplanetDetailPage({super.key, required this.planet});

  Future<void> openPlanet(Map planet) async {
    final String baseUrl =
        "https://exoplanetarchive.ipac.caltech.edu/overview/";

    final String encodedName =
        Uri.encodeComponent(planet['pl_name']);

    final Uri url = Uri.parse("$baseUrl$encodedName");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(planet['pl_name'] ?? 'Exoplanet'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🪐 NOM
            Text(
              planet['pl_name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => openPlanet(planet),
                child: Icon(
                  Icons.public,
                  size: 80,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            const SizedBox(height: 20),

            _info("🌍 Masse", "${planet['pl_bmasse']}"),
            _info("📏 Rayon", "${planet['pl_rade']}"),
            _info("📡 Distance", "${planet['sy_dist']} pc"),
            _info("🌡 Température", "${planet['pl_eqt']} K"),
            _info("🗓 Découverte", "${planet['disc_year']}"),
            _info("🔭 Méthode", "${planet['discoverymethod']}"),

          ],
        ),
      ),
    );
  }


  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "$label : $value",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}