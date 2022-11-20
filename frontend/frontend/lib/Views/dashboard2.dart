import 'package:flutter/material.dart';
import 'package:frontend/Graphs/serverCountbyCountry.dart';
import 'package:frontend/Graphs/topchartbycountry.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DashBoard2 extends StatelessWidget {
  const DashBoard2({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.COLUMN,
      children: [
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: ResponsiveRowColumn(
            layout: ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                child: Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: TopChartByCountry(),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: ServerChartBuCountry(),
                ),
              ),
            ],
          ),
        ),
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: ResponsiveRowColumn(
            layout: ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
            rowPadding: const EdgeInsets.symmetric(vertical: 10),
            children: [],
          ),
        ),
      ],
    );
  }
}
