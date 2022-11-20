import 'dart:convert';

import 'package:frontend/locator.dart';
import 'package:sqlite3/sqlite3.dart';

class PacketTable {
  final Database db = locator.get<Database>();

  List<PacketModel> result = [];
  PacketTable() {
    createTable();
  }
  createTable() {
    db.execute("""
    CREATE TABLE IF NOT EXISTS packetStore(
	"srcip"	TEXT,
	"dstip"	TEXT,
	"srcmac"	TEXT,
	"dstmac"	TEXT,
	"rawData"	BLOB,
  "createddate"	TEXT
  );
  """);
  }

  List<PacketModel> getAll() {
    // if (result.) {
    final ResultSet res = db.select("""
SELECT * from packetStore
""");
    for (Row row in res) {
      result.add(PacketModel.fromJson(row));
    }
    // }
    return result;
  }

  insertValue(PacketModel data) {
    if (data.dstip == null || data.dstip!.isEmpty || data.dstip == 'null') {
      // logger.i("Skiped Insert in packet for ${data.toString()}");
      return;
    }

    String query =
        'INSERT INTO packetStore ("srcip","dstip","srcmac","dstmac","rawData","createddate") VALUES (\'${data.srcip}\',\'${data.dstip}\',\'${data.srcMac}\',\'${data.dstmac}\',\'${data.rawData}\',\'${DateTime.now()}\');';
    // logger.d("Query for PacketModel --> $query");
    db.execute(query);
  }

  Map<String, IpTableWithCount> getTopTalkers() {
    Map<String, IpTableWithCount> result = <String, IpTableWithCount>{};

    final ResultSet res = db.select("""
      SELECT count(dstip) as dstipValue,dstip,iplookup.hostname as hostname ,iplookup.org as org ,iplookup.country as country,SUM(COUNT(dstip)) OVER() AS total_count,iplookup.loc as loc
  FROM packetStore 
  INNER JOIN iplookup on iplookup.ip = packetStore.dstip
  GROUP BY iplookup.org
  LIMIT 6;
""");
    for (Row row in res) {
      result.putIfAbsent(row["dstip"], () => IpTableWithCount.fromJson(row));
    }
    return result;
  }

  insertList(List<PacketModel> res) {
    final stmt = db.prepare("""
  INSERT INTO packetStore ("srcip","dstip","srcmac","dstmac","rawData","createddate") VALUES (?,?,?,?,?,?);

""");
    stmt.execute(res);
  }

  deleteAll() {
    db.execute("DELETE FROM packetStore");
  }
}

class PacketModel {
  String? srcip;
  String? srcMac;
  String? dstip;
  String? dstmac;
  String? rawData;
  String? createddate;
  PacketModel(
      {this.dstip = "",
      this.dstmac = "",
      this.srcMac = "",
      this.srcip = "",
      this.rawData = "",
      this.createddate = ""});
  PacketModel.fromJson(Map<String, dynamic> json) {
    dstip = json['dstip'];
    srcip = json['srcip'];
    srcMac = json['srcMac'];
    dstmac = json['dstmac'];
    rawData = json['rawData'];
    createddate = json['createddate'];
  }
  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['dstip'] = "'$dstip'";
    data['srcip'] = "'$srcip'";
    data['srcMac'] = "'$srcMac'";
    data['dstmac'] = "'$dstmac'";
    data['rawData'] = rawData!.replaceAll("\\", "");
    data['createddate'] = createddate.toString();
    return data;
  }

  @override
  String toString() => "$srcip->$srcMac->$dstip->$dstmac->$rawData->$createddate";
}

class IpTableWithCount {
  String? dstipValue;
  String? dstip;
  String? hostname;
  String? org;
  String? country;
  int? totalcount;
  String? loc;
  IpTableWithCount(
      {this.dstipValue,
      this.dstip,
      this.hostname,
      this.org,
      this.country,
      this.loc,
      this.totalcount});

  IpTableWithCount.fromJson(Map<String, dynamic> json) {
    dstipValue = json['dstipValue'].toString();
    dstip = json['dstip'].toString();
    hostname = json['hostname'];
    org = json['org'];
    country = json['country'];
    totalcount = json['total_count'];
    loc = json['loc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dstipValue'] = dstipValue;
    data['dstip'] = dstip;
    data['hostname'] = hostname;
    data['org'] = org;
    data['country'] = country;
    data['total_count'] = totalcount;
    data['loc'] = loc;
    return data;
  }
}
