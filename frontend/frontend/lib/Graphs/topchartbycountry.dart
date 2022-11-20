import 'dart:math' as matb;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:frontend/Core/ViewModel/dashboardtwoviewmodel.dart';
import 'package:provider/provider.dart';

class TopChartByCountry extends StatelessWidget {
  const TopChartByCountry({super.key});

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Color(0xff020227),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Top Countries Packets Recieved',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Consumer<DashBoardTwoViewModel>(
                        builder: (context, value, child) => BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.blueGrey,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                                    BarTooltipItem(
                                  '${value.topbycountrys[groupIndex].country}\n',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: value.topbycountrys[groupIndex].dstipValue,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              touchCallback: (FlTouchEvent event, barTouchResponse) {
                                if (!event.isInterestedForInteractions ||
                                    barTouchResponse == null ||
                                    barTouchResponse.spot == null) {
                                  return;
                                }
                                value.updateTocuchedIndexForTopByCountries(
                                    barTouchResponse.spot!.touchedBarGroupIndex);
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, meta) => SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 16,
                                    child: Text(
                                      value.topbycountrys[val.toInt()].dstipValue ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  ),
                                  reservedSize: 38,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: value.topbycountrys.map((e) {
                              double doubelValue =
                                  matb.log(double.parse(e.dstipValue ?? "0")) / matb.ln10;
                              return BarChartGroupData(
                                x: i++,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.touchedIndex ? doubelValue + 1 : doubelValue,
                                    color: e.touchedIndex ? Colors.yellow : Colors.purple.shade700,
                                    width: 20,
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 10,
                                      color: Colors.purple.shade900,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
