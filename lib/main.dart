import 'package:flutter/material.dart';
import 'data/api/nasa_api.dart';

import 'presentation/widgets/mass_chart.dart';
import 'presentation/widgets/distance_histogram.dart';
import 'presentation/widgets/temperature_histogram.dart';
import 'presentation/widgets/radius_histogram.dart';
import 'presentation/widgets/discovery_timeline_chart.dart';

import 'presentation/pages/exoplanet_detail_page.dart';

void main() {
  runApp(const NASAApp());
}

class NASAApp extends StatelessWidget {
  const NASAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NASA Exoplanets",
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List data = [];
  bool loading = true;
  int totalCount = 0;
  List methods = [];
  List yearlyData = [];

  @override
  void initState() {
    super.initState();
    load();
    loadCount(); // 🔥 NOUVEAU
    loadMethods(); // 🔥 NOUVEAU
    loadYearlyData(); // 🔥 NOUVEAU
    
  }

  Future<void> load() async {
    try {
      final result = await NasaApi.fetchExoplanets();

      setState(() {
        data = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        data = [];
        loading = false;
      });
      debugPrint("NASA ERROR: $e");
    }
  }

  Future<void> loadCount() async {
    try {
      final count = await NasaApi.fetchExoplanetCount();

      setState(() {
        totalCount = count;
      });
    } catch (e) {
      debugPrint("COUNT ERROR: $e");
    }
  }

  Future<void> loadMethods() async {
    try {
      final result = await NasaApi.fetchDiscoveryMethods();

      setState(() {
        methods = result;
      });
    } catch (e) {
      debugPrint("METHOD ERROR: $e");
    }
  }


    Future<void> loadYearlyData() async {
      try {
        final result = await NasaApi.fetchDiscoveryByYear();
  
        setState(() {
          yearlyData = result;
        });
      } catch (e) {
        debugPrint("YEARLY DATA ERROR: $e");
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("NASA EXOPLANETS"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                //loading ? "..." : "${data.length}",
                totalCount == 0 ? "..." : "$totalCount",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: loading
    ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 10),

            // 🌌 HEADER
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "EXOPLANET DASHBOARD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "NASA Exoplanet Archive",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // 📊 CHARTS
            SizedBox(
              height: 260,
              child: MassChart(data: data.take(1000).toList()),
            ),

            SizedBox(
              height: 300,
              child: DistanceHistogram(data: data.take(1000).toList()),
            ),

            SizedBox(
              height: 260,
              child: TemperatureHistogram(data: data.take(1000).toList()),
            ),

            SizedBox(
              height: 260,
              child: RadiusHistogram(data: data.take(1000).toList()),
            ),

            const SizedBox(height: 20),

            // 🔢 COUNT INFO
            Text(
              "Résultats: ${data.length}",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
              ),
            ),

            DiscoveryTimelineChart(data: yearlyData),

            const SizedBox(height: 10),

            // 📜 LISTE EXOPLANÈTES (IMPORTANT)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) {
                final p = data[i];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExoplanetDetailPage(planet: p),
                        ),
                      );
                    },

                    leading: Hero(
                      tag: p['pl_name'],
                      child: const Icon(
                        Icons.public,
                        color: Colors.blueAccent,
                      ),
                    ),

                    title: Text(
                      p['pl_name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🌍 Masse: ${p['pl_bmasse']} | 📏 Rayon: ${p['pl_rade']}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "📡 Distance: ${p['sy_dist']} pc | 🌡 Temp: ${p['pl_eqt']} K",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "🗓 Découverte: ${p['disc_year'] ?? 'unknown'}",
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 📋 TABLE MÉTHODES (TOUJOURS EN BAS)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B132B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Méthodes de découverte",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Méthode",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Nb",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ...methods.map((m) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                m['discoverymethod'] ?? 'Unknown',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                "${m['n']}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}