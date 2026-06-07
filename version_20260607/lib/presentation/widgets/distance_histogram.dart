import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DistanceHistogram extends StatelessWidget {
  final List data;

  const DistanceHistogram({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int b0_5 = 0;
    int b5_10 = 0;
    int b10_15 = 0;
    int b15_20 = 0;
    int b20_25 = 0;
    int b25_plus = 0;
    int unknown = 0;

    for (var p in data) {
      final d = p['sy_dist'];

      if (d == null) {
        unknown++;
      } else if (d < 5) {
        b0_5++;
      } else if (d < 10) {
        b5_10++;
      } else if (d < 15) {
        b10_15++;
      } else if (d < 20) {
        b15_20++;
      } else if (d < 25) {
        b20_25++;
      } else {
        b25_plus++;
      }
    }

    final values = [
      b0_5,
      b5_10,
      b10_15,
      b15_20,
      b20_25,
      b25_plus,
      unknown,
    ];

    final maxY = (values.reduce((a, b) => a > b ? a : b)).toDouble() + 2;

    return Column(
      children: [

        // 📌 TITLE FIXED
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            "Répartition des distances (parsecs)",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 📊 CHART SAFE HEIGHT
        SizedBox(
          height: 240,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),

                // ❌ TOOLTIP SIMPLIFIÉ (IMPORTANT)
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "${_labels[group.x]} : ${rod.toY.toInt()}",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= _labels.length) {
                          return const SizedBox();
                        }
                        return Text(
                          _labels[value.toInt()],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(values.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i].toDouble(),
                        width: 14,
                        color: _color(i),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: const [
            _Legend(color: Colors.green, text: "0–5 pc"),
            _Legend(color: Colors.lightGreen, text: "5–10 pc"),
            _Legend(color: Colors.blue, text: "10–15 pc"),
            _Legend(color: Colors.indigo, text: "15–20 pc"),
            _Legend(color: Colors.orange, text: "20–25 pc"),
            _Legend(color: Colors.red, text: "25+ pc"),
            _Legend(color: Colors.grey, text: "Inconnu"),
          ],
        ),
      ],
    );
  }

  static const List<String> _labels = [
    "0-5",
    "5-10",
    "10-15",
    "15-20",
    "20-25",
    "25+",
    "?"
  ];

  Color _color(int i) {
    switch (i) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.lightGreen;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigo;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }
}