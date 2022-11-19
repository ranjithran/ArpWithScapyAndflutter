import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/Core/Db/packet_table.dart';
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
  List<Color> colors = const [
    Color(0xffFB2576),
    Color(0xffC69749),
    Color(0xff16003B),
    Color(0xffC84B31),
    Color(0xffFF0000),
    Color(0xff4E9F3D)
  ];

  Map<String, IpTableWithCount> ipTableWithCount = <String, IpTableWithCount>{};

  void init() {
    ipTableWithCount = _packetTable.getTopTalkers();
    int i = -1;
    //Chart Maths Goes here
    markers.clear();
    for (String val in ipTableWithCount.keys) {
      Color color = colors[i++ % 6];
      indicator
          .add(Indicator(color: color, text: ipTableWithCount[val]!.org ?? "", isSquare: false));
      piedata.add(
        PieData(
          value: (double.parse(ipTableWithCount[val]!.dstipValue ?? "0") /
                  ipTableWithCount[val]!.totalcount!) *
              100,
          color: color,
        ),
      );
      List<String> latlag = ipTableWithCount[val]!.loc!.split(",");

      markers.add(Marker(
        point: LatLng(double.parse(latlag[0]), double.parse(latlag[1])),
        builder: (context) => const Icon(Icons.pin_drop,color: Colors.red,),
      ));
    }
  }
}

class PieData {
  double value;
  Color color;
  PieData({
    required this.value,
    required this.color,
  });

  String get title => "${value.toStringAsFixed(1)} %";
}
