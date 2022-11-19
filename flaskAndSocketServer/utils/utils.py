from typing import List, Dict


def processNmapTojson(nmapreport: Dict) -> List:
    finalResult = []
    for i in nmapreport['scan']:
        tmp = {
            "ip": str(nmapreport['scan'][i]['hostnames'][0]['name']),
            "ipv4": str(nmapreport['scan'][i]['addresses']['ipv4']),
            "mac": str(nmapreport['scan'][i]['addresses']['mac'] if (len(nmapreport['scan'][i]['addresses'].keys()) > 1) else ''),
            "state": str(nmapreport['scan'][i]['status']['state']),
            "reason": str(nmapreport['scan'][i]['status']['reason']),
        }
        if (nmapreport['scan'][i]['vendor'] != {}):
            tmp["vendor"] = str(nmapreport['scan'][i]['vendor'][tmp["mac"]])
        else:
            tmp["vendor"]=""    
        finalResult.append(tmp)
    return finalResult
