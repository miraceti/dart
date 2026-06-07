import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadiusHistogram extends StatelessWidget {
  final List data;

  const RadiusHistogram({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<double> r = [];

    for (var p in data) {
      final v = p['pl_rade'];
      if (v != null) {
        r.add(v.toDouble());
      }
    }

    int a = 0, b = 0, c = 0, d = 0;

    for (var v in r) {
      if (v < 1) a++;
      else if (v < 2) b++;
      else if (v < 5) c++;
      else d++;
    }

    final values = [a, b, c, d];
    final maxY = values.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return Column(
      children: [
        const Text(
          "Rayon des exoplanètes (R⊕)",
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
                      color: Colors.blue,
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
                      const labels = ["<1", "1-2", "2-5", ">5"];
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