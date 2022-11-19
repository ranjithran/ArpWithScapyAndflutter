
import 'package:frontend/locator.dart';
import 'package:sqlite3/sqlite3.dart';

class IpLookUpTable {
  final Database _db = locator.get<Database>();
  Set<IPLookUpModel> unqiueIpLookUpValues = {};
  IpLookUpTable() {
    Future.microtask(() => selectAllIps());
  }
  void createTable() {
    _db.execute("""
  CREATE TABLE IF NOT EXISTS iplookup (
	"ip"	TEXT NOT NULL UNIQUE,
	"hostname"	TEXT,
	"city"	TEXT,
	"region"	TEXT,
	"country"	TEXT,
	"loc"	TEXT,
	"org"	TEXT,
  "postal" TEXT,
	"timezone"	TEXT,
	PRIMARY KEY("ip")
  );
    """);
  }

  void insertData(IPLookUpModel data) {
    if (data.org == '' || data.org == 'null' || data.org == null) {
      logger.i("Skiped insert for ${data.toString()}");
      return;
    }
    String query =
        'INSERT INTO iplookup("ip","hostname","city","region","country","loc","org","postal","timezone") VALUES (\'${data.ip}\',\'${data.hostname}\',\'${data.city}\',\'${data.region}\',\'${data.country}\',\'${data.loc}\',\'${data.org}\',\'${data.postal}\',\'${data.timezone}\')';
    logger.d("Insert IPlookUp query-> $query");
    unqiueIpLookUpValues.add(data);
    _db.execute(query);
  }

  Set<IPLookUpModel> selectAllIps() {
    String query = "SELECT * FROM iplookup LIMIT 0, 49999;";
    final ResultSet res = _db.select(query);
    for (Row element in res) {
      unqiueIpLookUpValues.add(IPLookUpModel.fromJson(element));
    }
    logger.d("Totols IpLookUps ->${unqiueIpLookUpValues.length}");
    return unqiueIpLookUpValues;
  }
}

class IPLookUpModel {
  String? ip;
  String? hostname;
  String? city;
  String? region;
  String? country;
  String? loc;
  String? org;
  String? postal;
  String? timezone;

  IPLookUpModel(
      {this.ip,
      this.hostname,
      this.city,
      this.region,
      this.country,
      this.loc,
      this.org,
      this.postal,
      this.timezone});

  IPLookUpModel.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    hostname = json['hostname'];
    city = json['city'];
    region = json['region'];
    country = json['country'];
    loc = json['loc'];
    if (json['org'] != null) {
      org = json['org']
          .toString()
          .substring(json['org'].toString().indexOf(" "), json['org'].toString().length);
    }
    postal = json['postal'];
    timezone = json['timezone'];
  }
  @override
  bool operator ==(Object other) =>
      other is IPLookUpModel && other.runtimeType == runtimeType && other.ip == ip;

  @override
  int get hashCode => ip.hashCode;
  @override
  @override
  String toString() =>
      "$ip $hostname $city $region $country $loc $org $postal $timezone";
}
