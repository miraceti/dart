import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiscoveryTimelineChart extends StatelessWidget {
  final List data;

  const DiscoveryTimelineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No data",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final spots = <FlSpot>[];

    for (var i = 0; i < data.length; i++) {
      final year = data[i]['disc_year'];
      final count = data[i]['n'];

      if (year != null && count != null) {
        spots.add(
          FlSpot(
            year.toDouble(),
            count.toDouble(),
          ),
        );
      }
    }

    return Column(
      children: [

        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Découvertes d'exoplanètes par année",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        SizedBox(
          height: 240,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),

              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}