class SnifferDataJsonModel {
  Ethernet? ethernet;
  IP? iP;
  TCP? tCP;
  IPv6? iPv6;
  HTTPRequest? hTTPRequest;
  DateTime time = DateTime.now();
  SnifferDataJsonModel({this.ethernet, this.iP, this.tCP, this.hTTPRequest});

  SnifferDataJsonModel.fromJson(Map<String, dynamic> json) {
    ethernet = json['Ethernet'] != null ? Ethernet.fromJson(json['Ethernet']) : null;
    iP = json['IP'] != null ? IP.fromJson(json['IP']) : null;
    tCP = json['TCP'] != null ? TCP.fromJson(json['TCP']) : null;
    iPv6 = json['IPv6'] != null ? IPv6.fromJson(json['IPv6']) : null;
    hTTPRequest = json['HTTP Request'] != null ? HTTPRequest.fromJson(json['HTTP Request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ethernet != null) {
      data['Ethernet'] = ethernet!.toJson();
    }
    if (iP != null) {
      data['IP'] = iP!.toJson();
    }
    if (tCP != null) {
      data['TCP'] = tCP!.toJson();
    }
    if (iPv6 != null) {
      data['IPv6'] = iPv6!.toJson();
    }
    if (hTTPRequest != null) {
      data['HTTP Request'] = hTTPRequest!.toJson();
    }
    return data;
  }
}

class Ethernet {
  String? dst;
  String? src;
  String? type;

  Ethernet({this.dst, this.src, this.type});

  Ethernet.fromJson(Map<String, dynamic> json) {
    dst = json['dst'];
    src = json['src'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dst'] = dst;
    data['src'] = src;
    data['type'] = type;
    return data;
  }
}

class IP {
  String? version;
  String? ihl;
  String? tos;
  String? len;
  String? id;
  String? flags;
  String? frag;
  String? ttl;
  String? proto;
  String? chksum;
  String? src;
  String? dst;

  IP(
      {this.version,
      this.ihl,
      this.tos,
      this.len,
      this.id,
      this.flags,
      this.frag,
      this.ttl,
      this.proto,
      this.chksum,
      this.src,
      this.dst});

  IP.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    ihl = json['ihl'];
    tos = json['tos'];
    len = json['len'];
    id = json['id'];
    flags = json['flags'];
    frag = json['frag'];
    ttl = json['ttl'];
    proto = json['proto'];
    chksum = json['chksum'];
    src = json['src'];
    dst = json['dst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['ihl'] = ihl;
    data['tos'] = tos;
    data['len'] = len;
    data['id'] = id;
    data['flags'] = flags;
    data['frag'] = frag;
    data['ttl'] = ttl;
    data['proto'] = proto;
    data['chksum'] = chksum;
    data['src'] = src;
    data['dst'] = dst;
    return data;
  }
}

class TCP {
  String? sport;
  String? dport;
  String? seq;
  String? ack;
  String? dataofs;
  String? reserved;
  String? flags;
  String? window;
  String? chksum;
  String? urgptr;
  String? options;

  TCP(
      {this.sport,
      this.dport,
      this.seq,
      this.ack,
      this.dataofs,
      this.reserved,
      this.flags,
      this.window,
      this.chksum,
      this.urgptr,
      this.options});

  TCP.fromJson(Map<String, dynamic> json) {
    sport = json['sport'];
    dport = json['dport'];
    seq = json['seq'];
    ack = json['ack'];
    dataofs = json['dataofs'];
    reserved = json['reserved'];
    flags = json['flags'];
    window = json['window'];
    chksum = json['chksum'];
    urgptr = json['urgptr'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sport'] = sport;
    data['dport'] = dport;
    data['seq'] = seq;
    data['ack'] = ack;
    data['dataofs'] = dataofs;
    data['reserved'] = reserved;
    data['flags'] = flags;
    data['window'] = window;
    data['chksum'] = chksum;
    data['urgptr'] = urgptr;
    data['options'] = options;
    return data;
  }
}

class HTTPRequest {
  String? method;
  String? path;
  String? httpVersion;
  String? aIM;
  String? accept;
  String? acceptCharset;
  String? acceptDatetime;
  String? acceptEncoding;
  String? acceptLanguage;
  String? accessControlRequestHeaders;
  String? accessControlRequestMethod;
  String? authorization;
  String? cacheControl;
  String? connection;
  String? contentLength;
  String? contentMD5;
  String? contentType;
  String? cookie;
  String? dNT;
  String? date;
  String? expect;
  String? forwarded;
  String? from;
  String? frontEndHttps;
  String? hTTP2Settings;
  String? host;
  String? ifMatch;
  String? ifModifiedSince;
  String? ifNoneMatch;
  String? ifRange;
  String? ifUnmodifiedSince;
  String? keepAlive;
  String? maxForwards;
  String? origin;
  String? permanent;
  String? pragma;
  String? proxyAuthorization;
  String? proxyConnection;
  String? range;
  String? referer;
  String? saveData;
  String? tE;
  String? upgrade;
  String? upgradeInsecureRequests;
  String? userAgent;
  String? via;
  String? warning;
  String? xATTDeviceId;
  String? xCorrelationID;
  String? xCsrfToken;
  String? xForwardedFor;
  String? xForwardedHost;
  String? xForwardedProto;
  String? xHttpMethodOverride;
  String? xRequestID;
  String? xRequestedWith;
  String? xUIDH;
  String? xWapProfile;
  String? unknownHeaders;

  HTTPRequest(
      {this.method,
      this.path,
      this.httpVersion,
      this.aIM,
      this.accept,
      this.acceptCharset,
      this.acceptDatetime,
      this.acceptEncoding,
      this.acceptLanguage,
      this.accessControlRequestHeaders,
      this.accessControlRequestMethod,
      this.authorization,
      this.cacheControl,
      this.connection,
      this.contentLength,
      this.contentMD5,
      this.contentType,
      this.cookie,
      this.dNT,
      this.date,
      this.expect,
      this.forwarded,
      this.from,
      this.frontEndHttps,
      this.hTTP2Settings,
      this.host,
      this.ifMatch,
      this.ifModifiedSince,
      this.ifNoneMatch,
      this.ifRange,
      this.ifUnmodifiedSince,
      this.keepAlive,
      this.maxForwards,
      this.origin,
      this.permanent,
      this.pragma,
      this.proxyAuthorization,
      this.proxyConnection,
      this.range,
      this.referer,
      this.saveData,
      this.tE,
      this.upgrade,
      this.upgradeInsecureRequests,
      this.userAgent,
      this.via,
      this.warning,
      this.xATTDeviceId,
      this.xCorrelationID,
      this.xCsrfToken,
      this.xForwardedFor,
      this.xForwardedHost,
      this.xForwardedProto,
      this.xHttpMethodOverride,
      this.xRequestID,
      this.xRequestedWith,
      this.xUIDH,
      this.xWapProfile,
      this.unknownHeaders});

  HTTPRequest.fromJson(Map<String, dynamic> json) {
    method = json['Method'];
    path = json['Path'];
    httpVersion = json['Http_Version'];
    aIM = json['A_IM'];
    accept = json['Accept'];
    acceptCharset = json['Accept_Charset'];
    acceptDatetime = json['Accept_Datetime'];
    acceptEncoding = json['Accept_Encoding'];
    acceptLanguage = json['Accept_Language'];
    accessControlRequestHeaders = json['Access_Control_Request_Headers'];
    accessControlRequestMethod = json['Access_Control_Request_Method'];
    authorization = json['Authorization'];
    cacheControl = json['Cache_Control'];
    connection = json['Connection'];
    contentLength = json['Content_Length'];
    contentMD5 = json['Content_MD5'];
    contentType = json['Content_Type'];
    cookie = json['Cookie'];
    dNT = json['DNT'];
    date = json['Date'];
    expect = json['Expect'];
    forwarded = json['Forwarded'];
    from = json['From'];
    frontEndHttps = json['Front_End_Https'];
    hTTP2Settings = json['HTTP2_Settings'];
    host = json['Host'];
    ifMatch = json['If_Match'];
    ifModifiedSince = json['If_Modified_Since'];
    ifNoneMatch = json['If_None_Match'];
    ifRange = json['If_Range'];
    ifUnmodifiedSince = json['If_Unmodified_Since'];
    keepAlive = json['Keep_Alive'];
    maxForwards = json['Max_Forwards'];
    origin = json['Origin'];
    permanent = json['Permanent'];
    pragma = json['Pragma'];
    proxyAuthorization = json['Proxy_Authorization'];
    proxyConnection = json['Proxy_Connection'];
    range = json['Range'];
    referer = json['Referer'];
    saveData = json['Save_Data'];
    tE = json['TE'];
    upgrade = json['Upgrade'];
    upgradeInsecureRequests = json['Upgrade_Insecure_Requests'];
    userAgent = json['User_Agent'];
    via = json['Via'];
    warning = json['Warning'];
    xATTDeviceId = json['X_ATT_DeviceId'];
    xCorrelationID = json['X_Correlation_ID'];
    xCsrfToken = json['X_Csrf_Token'];
    xForwardedFor = json['X_Forwarded_For'];
    xForwardedHost = json['X_Forwarded_Host'];
    xForwardedProto = json['X_Forwarded_Proto'];
    xHttpMethodOverride = json['X_Http_Method_Override'];
    xRequestID = json['X_Request_ID'];
    xRequestedWith = json['X_Requested_With'];
    xUIDH = json['X_UIDH'];
    xWapProfile = json['X_Wap_Profile'];
    unknownHeaders = json['Unknown_Headers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Method'] = method;
    data['Path'] = path;
    data['Http_Version'] = httpVersion;
    data['A_IM'] = aIM;
    data['Accept'] = accept;
    data['Accept_Charset'] = acceptCharset;
    data['Accept_Datetime'] = acceptDatetime;
    data['Accept_Encoding'] = acceptEncoding;
    data['Accept_Language'] = acceptLanguage;
    data['Access_Control_Request_Headers'] = accessControlRequestHeaders;
    data['Access_Control_Request_Method'] = accessControlRequestMethod;
    data['Authorization'] = authorization;
    data['Cache_Control'] = cacheControl;
    data['Connection'] = connection;
    data['Content_Length'] = contentLength;
    data['Content_MD5'] = contentMD5;
    data['Content_Type'] = contentType;
    data['Cookie'] = cookie;
    data['DNT'] = dNT;
    data['Date'] = date;
    data['Expect'] = expect;
    data['Forwarded'] = forwarded;
    data['From'] = from;
    data['Front_End_Https'] = frontEndHttps;
    data['HTTP2_Settings'] = hTTP2Settings;
    data['Host'] = host;
    data['If_Match'] = ifMatch;
    data['If_Modified_Since'] = ifModifiedSince;
    data['If_None_Match'] = ifNoneMatch;
    data['If_Range'] = ifRange;
    data['If_Unmodified_Since'] = ifUnmodifiedSince;
    data['Keep_Alive'] = keepAlive;
    data['Max_Forwards'] = maxForwards;
    data['Origin'] = origin;
    data['Permanent'] = permanent;
    data['Pragma'] = pragma;
    data['Proxy_Authorization'] = proxyAuthorization;
    data['Proxy_Connection'] = proxyConnection;
    data['Range'] = range;
    data['Referer'] = referer;
    data['Save_Data'] = saveData;
    data['TE'] = tE;
    data['Upgrade'] = upgrade;
    data['Upgrade_Insecure_Requests'] = upgradeInsecureRequests;
    data['User_Agent'] = userAgent;
    data['Via'] = via;
    data['Warning'] = warning;
    data['X_ATT_DeviceId'] = xATTDeviceId;
    data['X_Correlation_ID'] = xCorrelationID;
    data['X_Csrf_Token'] = xCsrfToken;
    data['X_Forwarded_For'] = xForwardedFor;
    data['X_Forwarded_Host'] = xForwardedHost;
    data['X_Forwarded_Proto'] = xForwardedProto;
    data['X_Http_Method_Override'] = xHttpMethodOverride;
    data['X_Request_ID'] = xRequestID;
    data['X_Requested_With'] = xRequestedWith;
    data['X_UIDH'] = xUIDH;
    data['X_Wap_Profile'] = xWapProfile;
    data['Unknown_Headers'] = unknownHeaders;
    return data;
  }
}

class IPv6 {
  String? version;
  String? tc;
  String? fl;
  String? plen;
  String? nh;
  String? hlim;
  String? src;
  String? dst;

  IPv6({this.version, this.tc, this.fl, this.plen, this.nh, this.hlim, this.src, this.dst});

  IPv6.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    tc = json['tc'];
    fl = json['fl'];
    plen = json['plen'];
    nh = json['nh'];
    hlim = json['hlim'];
    src = json['src'];
    dst = json['dst'];
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_new
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['tc'] = tc;
    data['fl'] = fl;
    data['plen'] = plen;
    data['nh'] = nh;
    data['hlim'] = hlim;
    data['src'] = src;
    data['dst'] = dst;
    return data;
  }
}
