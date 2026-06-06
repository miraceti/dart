import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TemperatureHistogram extends StatelessWidget {
  final List data;

  const TemperatureHistogram({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<double> temps = [];

    for (var p in data) {
      final t = p['pl_eqt'];
      if (t != null) {
        temps.add(t.toDouble());
      }
    }

    int c0_200 = 0;
    int c200_300 = 0;
    int c300_500 = 0;
    int c500_plus = 0;

    for (var t in temps) {
      if (t < 200) {
        c0_200++;
      } else if (t < 300) {
        c200_300++;
      } else if (t < 500) {
        c300_500++;
      } else {
        c500_plus++;
      }
    }

    final values = [c0_200, c200_300, c300_500, c500_plus];
    final maxY = values.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return Column(
      children: [
        const Text(
          "Température des exoplanètes (K)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: List.generate(values.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i].toDouble(),
                      color: Colors.orange,
                      width: 18,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      const labels = ["<200", "200-300", "300-500", ">500"];
                      return Text(
                        labels[value.toInt()],
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}