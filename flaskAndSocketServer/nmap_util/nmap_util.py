import nmap

from ..utils import utils


class nMapUtil():

    def __init__(self):
        self.results = ""
        self.ip = ""
        self.nm = nmap.PortScanner()
        
    def runScanForMacAndVendors(self):
        if (self.results == ''):
            self.results = self.nm.scan(self.ip, arguments="-sP")
            self.results = utils.processNmapTojson(self.results)
            return self.results
        else:
            return self.results            
