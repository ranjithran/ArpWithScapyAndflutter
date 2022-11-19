import json
from flask import jsonify, request
from scapy.all import *
import datetime
from .. import app, scapyUtils
from ..nmap_util import nmap_util

nmap = nmap_util.nMapUtil()


@app.before_request
def do_something_whenever_a_request_comes_in():
    print(f"Requested {request.path} at -> {datetime.datetime.now()}")


@app.route("/getIfNames")
def getInterfaceNames():
    return jsonify(get_if_list())


@app.route("/getHostsMacscache")
def getHostsMacsWithIpsCached():

    ip = request.args.get('ip')+'/24'
    nmap.ip = ip
    print(ip)
    results = nmap.runScanForMacAndVendors()
    print("return result for nmap",results)
    return json.dumps({'results': results}), 200

@app.route("/getHostsMacs")
def getHostsMacsWithIps():

    ip = request.args.get('ip')+'/24'
    nmap.ip = ip
    print(ip)
    nmap.results=""
    results = nmap.runScanForMacAndVendors()
    print("return result for nmap",results)
    return json.dumps({'results': results}), 200

@app.route("/startArpWithScapy")
def startArpWithScapy():
    """
    Starting Arp for know mac's address
    """
    if scapyUtils.runArpPossingUsingScapy():
        return json.dumps({"status": "Strated Succfully"}), 200
    else:
        return json.dumps({"Error": "Src ip and Dst Ip mising"}), 500


@app.route("/stopArpWithScapy")
def stopArpWithScapy():
    if scapyUtils.stopArpPossingUsingScapy():
        return json.dumps({"status": "Stoped Succesfully"}), 200
    else:
        return json.dumps({"Error": "Something went worng"}), 500


@app.route("/startArpWithEtherCap")
def startArpWithEtherCap():
    if (scapyUtils.startetterCapForwithoutMac()):
        return json.dumps({"status": "Strated Succfully"}), 200
    else:
        return json.dumps({"Error": "Src ip and Dst Ip mising"}), 500


@app.route("/stopArpWithEtherCap")
def stopArpWithEtherCap():

    if scapyUtils.stopetterCapForWithoutMac():
        return json.dumps({"status": "Stoped Succesfully"}), 200
    else:
        return json.dumps({"Error": "Something went worng"}), 500


@app.route("/setSrcIpandMac")
def setSrcIpandMac():
    staus = []
    if ('srcIp' in request.args.keys()):
        ip = request.args.get("srcIp")
        scapyUtils.srcIp = ip
        staus.append("Updated Ip")
    if ('srcMac' in request.args.keys()):
        mac = request.args.get("srcMac")
        scapyUtils.srcmac = mac
        staus.append("Updated mac")
    return json.dumps({"status": scapyUtils.toJSON()}), 200


@app.route("/setDrcIpandMac")
def setDrcIpandMac():
    staus = []
    if ('dstIp' in request.args.keys()):
        ip = request.args.get("dstIp")
        scapyUtils.dstIp = ip
        staus.append("Updated Ip")
    if ('dstMac' in request.args.keys()):
        mac = request.args.get("dstMac")
        scapyUtils.dstmac = mac
        staus.append("Updated mac")
    return json.dumps({"status": scapyUtils.toJSON()}), 200


@app.route("/setIFace")
def setIface():
    if ('iface' in request.args.keys()):
        scapyUtils.networkIface = request.args.get("iface")
    return json.dumps({"status": scapyUtils.toJSON()}), 200


@app.route("/getServerData")
def serverData():
    return scapyUtils.toJSON()


@app.route("/")
def default():
    return jsonify("Conneted")
