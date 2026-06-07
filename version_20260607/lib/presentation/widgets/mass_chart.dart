import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MassChart extends StatelessWidget {
  final List data;

  const MassChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int low = 0;
    int medium = 0;
    int high = 0;
    int unknown = 0;

    for (var p in data) {
      final m = p['pl_bmasse'];

      if (m == null) {
        unknown++;
      } else if (m < 5) {
        low++;
      } else if (m < 50) {
        medium++;
      } else {
        high++;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Répartition des masses (M⊕)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 🥧 PIE CHART
              SizedBox(
                height: 240,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,

                    sections: [
                      PieChartSectionData(
                        value: low.toDouble(),
                        color: Colors.green,
                        title: "$low",
                        radius: 70,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: medium.toDouble(),
                        color: Colors.blue,
                        title: "$medium",
                        radius: 70,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: high.toDouble(),
                        color: Colors.red,
                        title: "$high",
                        radius: 70,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: unknown.toDouble(),
                        color: Colors.grey,
                        title: "$unknown",
                        radius: 70,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 📊 LEGEND (IMPORTANT sinon incompréhensible)
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: const [
                  _Legend(color: Colors.green, text: "< 5 M⊕"),
                  _Legend(color: Colors.blue, text: "5–50 M⊕"),
                  _Legend(color: Colors.red, text: "> 50 M⊕"),
                  _Legend(color: Colors.grey, text: "Inconnu"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}