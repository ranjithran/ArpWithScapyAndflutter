import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/Core/Db/packet_table.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/Graphs/top_traffic_pie.dart';
import 'package:frontend/locator.dart';
import 'package:latlong2/latlong.dart';

class DashBoardViewModel extends ChangeNotifier {
  DashBoardViewModel() {
    init();
  }
  final PacketTable _packetTable = locator.get<PacketTable>();

  List<Widget> indicator = [];

  List<PieData> piedata = [];

  List<Marker> markers = [];

  List<LatLng> points = [];

  List<Polygon> polygons = [];
  Map<String, double> mylat = {};
  List<Color> colors = const [
    Color(0xffFB2576),
    Color(0xffC69749),
    Color(0xff16003B),
    Color(0xffC84B31),
    Color(0xffFF0000),
    Color(0xff4E9F3D)
  ];

  Map<String, IpTableWithCount> ipTableWithCount = <String, IpTableWithCount>{};

  init() {
    ipTableWithCount = _packetTable.getTopTalkers();
    int i = -1;
    //Chart Maths Goes here
    markers.clear();
    piedata.clear();
    indicator.clear();
    points.clear();

    for (String val in ipTableWithCount.keys) {
      Color color = colors[i++ % 6];
      indicator.add(
        Indicator(
          color: color,
          text: ipTableWithCount[val]!.org ?? "",
          isSquare: false,
        ),
      );
      piedata.add(
        PieData(
          value: (double.parse(ipTableWithCount[val]!.dstipValue ?? "0") /
                  ipTableWithCount[val]!.totalcount!) *
              100,
          color: color,
          name: ipTableWithCount[val]!.org ?? "",
        ),
      );
      List<String> latlag = ipTableWithCount[val]!.loc!.split(",");

      markers.add(
        Marker(
          point: LatLng(double.parse(latlag[0]), double.parse(latlag[1])),
          builder: (context) => const Icon(
            Icons.pin_drop,
            color: Colors.red,
          ),
        ),
      );
      polygons.add(Polygon(points: [
        LatLng(mylat["latitude"] ?? 0, mylat["longitude"] ?? 0),
        LatLng(double.parse(latlag[0]), double.parse(latlag[1])),
      ]));
    }
    piedata.sort(((a, b) => a.value.compareTo(b.value)));
  }

  updataLocs() {
    for (Polygon polygon in polygons) {
      polygon.points[0].latitude = mylat["latitude"] ?? 0;
      polygon.points[0].longitude = mylat["longitude"] ?? 0;
    }

    notifyListeners();
  }
}

class PieData {
  double value;
  Color color;
  String name;
  PieData({
    required this.name,
    required this.value,
    required this.color,
  });

  String get title => "${value.toStringAsFixed(1)} %";
}
