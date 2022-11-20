import 'dart:convert';

HostsWithMac hostsWithMacFromJson(String str) => HostsWithMac.fromJson(json.decode(str));

String hostsWithMacToJson(HostsWithMac data) => json.encode(data.toJson());

class HostsWithMac {
  HostsWithMac({
    required this.results,
  });

  List<Result> results;

  factory HostsWithMac.fromJson(Map<String, dynamic> json) => HostsWithMac(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.ip = "",
    this.ipv4 = "",
    this.mac = "",
    this.state = "",
    this.reason = "",
    this.vendor = "",
  });

  String ip;
  String ipv4;
  String mac;
  String state;
  String reason;
  String vendor;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        ip: json["ip"],
        ipv4: json["ipv4"],
        mac: json["mac"],
        state: json["state"],
        reason: json["reason"],
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "ipv4": ipv4,
        "mac": mac,
        "state": state,
        "reason": reason,
        "vendor": vendor,
      };
}
