import 'dart:math' as matb;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:frontend/Core/ViewModel/dashboardtwoviewmodel.dart';
import 'package:provider/provider.dart';

class ServerChartBuCountry extends StatelessWidget {
  const ServerChartBuCountry({super.key});

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff020227),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Server Hitted by Vicitim In A Country ',
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
                                  '${value.serverCountByCountry[groupIndex].country}\n',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: value.serverCountByCountry[groupIndex].serverValue
                                          .toString(),
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
                                value.updateTocuchedIndexForserverCountByCountry(
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
                                      value.serverCountByCountry[val.toInt()].serverValue
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey),
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
                            barGroups: value.serverCountByCountry.map((e) {
                              double doubelValue = matb.log(e.serverValue ?? 1) / matb.ln2;

                              return makeGroupData(i++, doubelValue, isTouched: e.touchedIndex);
                            }).toList(),
                            gridData: FlGridData(show: false),
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 250),
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

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    required bool isTouched,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: Colors.lightBlue,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.purple.shade900,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
