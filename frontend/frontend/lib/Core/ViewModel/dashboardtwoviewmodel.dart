import 'package:flutter/cupertino.dart';
import 'package:frontend/Core/Db/ip_look_up.dart';
import 'package:frontend/Core/Db/packet_table.dart';
import 'package:frontend/locator.dart';

class DashBoardTwoViewModel extends ChangeNotifier {
  PacketTable _packetTable = locator.get<PacketTable>();
  IpLookUpTable _ipLookUpTable = locator.get<IpLookUpTable>();
  DashBoardTwoViewModel() {
    init();
  }
  List<IpTableWithCount> topbycountrys = [];
  List<ServerCountByCountry> serverCountByCountry = [];
  void init() {
    topbycountrys = _packetTable.getTopTalkersByCountires();
    serverCountByCountry = _ipLookUpTable.getDataByServerCountOncountry();
  }

  int topbycountrysprev = -1;
  updateTocuchedIndexForTopByCountries(int value) {
    if (topbycountrysprev != -1 && value >= 0) {
      topbycountrys[topbycountrysprev].touchedIndex = false;
      topbycountrys[value].touchedIndex = true;
      topbycountrysprev = value;
      notifyListeners();
    }
  }

  int serverCountByCountrypre = -1;
  updateTocuchedIndexForserverCountByCountry(int value) {
    if (serverCountByCountrypre != -1 && value >= 0) {
      topbycountrys[serverCountByCountrypre].touchedIndex = false;
      topbycountrys[value].touchedIndex = true;
      serverCountByCountrypre = value;
      notifyListeners();
    }
  }
}
