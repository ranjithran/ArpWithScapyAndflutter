import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model.dart';
import 'package:frontend/Core/ViewModel/dashboardviewmodel.dart';
import 'package:frontend/Graphs/top_traffic_pie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return (ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.COLUMN,
      children: [
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: ResponsiveRowColumn(
            layout: ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.all(10),
                  child: Card(
                    color: const Color(0xff2C3333),
                    child: Consumer<CustomAppViewModel>(
                      builder: (context, value, child) => SimpleCircularProgressBar(
                        size: 150,
                        // valueNotifier: valueNotifier,
                        progressStrokeWidth: 10,
                        backStrokeWidth: 10,
                        mergeMode: true,
                        onGetText: (val) {
                          return Text(
                            '${value.devicesList} Devices',
                            style: const TextStyle(fontSize: 20),
                          );
                        },
                        progressColors: const [Colors.cyan, Colors.purple],
                        backColor: Colors.black.withOpacity(0.4),
                        animationDuration: 10,
                      ),
                    ),
                  ),
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Consumer<DashBoardViewModel>(
                        builder: (context, value, child) => FlutterMap(
                              options: MapOptions(
                                zoom: 1,
                                minZoom: 1,
                                maxZoom: 5,
                              ),
                              nonRotatedChildren: [
                                AttributionWidget.defaultWidget(
                                  source: 'OpenStreetMap contributors',
                                  onSourceTapped: () {},
                                ),
                              ],
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                                ),
                                MarkerLayer(markers: value.markers),
                              ],
                            )),
                  ),
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
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Card(
                    elevation: 2,
                    child: ResponsiveRowColumn(
                      layout: ResponsiveRowColumnType.COLUMN,
                      columnCrossAxisAlignment: CrossAxisAlignment.start,
                      columnMainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveRowColumnItem(
                          columnFlex: 0,
                          child: Container(
                              margin: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
                              child: const Text("WAN: Top Remote Destinations")),
                        ),
                        ResponsiveRowColumnItem(
                          columnFlex: 5,
                          columnFit: FlexFit.tight,
                          child: Consumer<DashBoardViewModel>(
                            builder: (context, value, child) => ListView.builder(
                              itemCount: value.ipTableWithCount.values.length,
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                child: ListTile(
                                  title:
                                      Text("${value.ipTableWithCount.values.toList()[index].org}"),
                                  subtitle: Text(
                                      "IP ->${value.ipTableWithCount.values.toList()[index].dstip}"),
                                  trailing:
                                      (value.ipTableWithCount.values.toList()[index].country !=
                                              'null')
                                          ? Image.asset(
                                              'icons/flags/png/${value.ipTableWithCount.values.toList()[index].country!.toLowerCase()}.png',
                                              package: 'country_icons',
                                              height: 15,
                                              width: 20,
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Container(
                    child: Provider.of<DashBoardViewModel>(context, listen: true)
                                .ipTableWithCount
                                .values
                                .length >
                            1
                        ? const PieChartSample2()
                        : const Center(child: Text("Plz Start Attack")),
                  ),
                )
              ]),
        ),
      ],
    ));
  }
}
