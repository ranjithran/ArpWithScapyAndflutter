import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Core/ViewModel/network_speed_viewmodel.dart';
import 'package:provider/provider.dart';

class LineChartSample10 extends StatelessWidget {
  const LineChartSample10({super.key});

  final Color sinColor = Colors.redAccent;

  final Color cosColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    // if (locator.get<io.Socket>().active) locator.get<NetWorkSpeedViewModel>().startNetWorkSpeed();
    return Consumer<NetWorkSpeedViewModel>(builder: (context, value, child) {
      return value.cosPoints.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 100,
                  child: LineChart(
                    LineChartData(
                        minY: -0.8,
                        maxY: 0.8,
                        minX: value.sinPoints.first.x,
                        maxX: value.sinPoints.last.x,
                        lineTouchData: LineTouchData(enabled: false),
                        clipData: FlClipData.all(),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        lineBarsData: [
                          sinLine(value.sinPoints),
                          cosLine(value.cosPoints),
                        ],
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        borderData: FlBorderData(show: false)),
                  ),
                )
              ],
            )
          : Container();
    });
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [sinColor.withOpacity(0), sinColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 1,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [sinColor.withOpacity(0), sinColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 1,
      isCurved: false,
    );
  }
}
