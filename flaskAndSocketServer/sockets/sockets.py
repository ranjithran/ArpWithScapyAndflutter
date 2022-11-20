import json
from threading import Event
from .. import scapyUtils
import psutil
from flaskAndSocketServer import socketio, scapyUtils, logger


thread_event = Event()
thread = None
thread_eventforSpeed = Event()
thread_forSpeed = None


def send_packetData(event, q):
    global thread
    try:
        while event.is_set():
            if (len(q)>0):
                
                l=0
                if(len(q)>2):
                    l=int(len(q)/2)
                socketio.emit('my_response', q)
                if(l!=0):
                    
                    del q[0:l]
                else:
                    q.pop(0)    
                socketio.sleep(seconds=2)
    finally:
        event.clear()
        thread = None


def send_netSpeed(event):
    global thread_forSpeed
    try:
        inf = "eth0"
        while event.is_set():
            net_stat = psutil.net_io_counters(pernic=True, nowrap=True)[inf]
            net_in_1 = net_stat.bytes_recv
            net_out_1 = net_stat.bytes_sent
            socketio.sleep(5)
            net_stat = psutil.net_io_counters(pernic=True, nowrap=True)[inf]
            net_in_2 = net_stat.bytes_recv
            net_out_2 = net_stat.bytes_sent
            net_in = round((net_in_2 - net_in_1) / 1024 / 1024, 3)
            net_out = round((net_out_2 - net_out_1) / 1024 / 1024, 3)
            socketio.emit("networkspeed", {"in": net_in, "out": net_out})
    finally:
        event.clear()
        thread_forSpeed = None


@socketio.on("startNetWorkSpeed")
def startNetworkSpeed(data):
    global thread_forSpeed
    if thread_forSpeed is None:
        thread_eventforSpeed.set()
        thread_forSpeed = socketio.start_background_task(
            send_netSpeed, thread_eventforSpeed)
        log("netWorkSpeed Emitter Started")


@socketio.on("stopNetWorkSpeed")
def stopNetworkSpeed(data):
    global thread_forSpeed
    thread_eventforSpeed.clear()
    if thread_forSpeed is not None:
        thread_forSpeed.join()
        thread_forSpeed = None
        log("stopNetWorkSpeed")


@socketio.on('startSniffer')
def startSniffer(data):
    log("called --> /"+data)
    global thread
    if thread is None:
        thread_event.set()
        scapyUtils.startSniffAsync()
        thread = socketio.start_background_task(
            send_packetData, thread_event, scapyUtils._queue)
        log("create sniffer in thread")

@socketio.on("stopSniffer")
def stopSniffer(data):
    log("called --> /"+data)
    global thread
    thread_event.clear()
    if thread is not None:
        thread.join()
        scapyUtils.sstopSniffer()
        thread = None
        log("Sniffer stopped")


@socketio.on('connect')
def connect():
    log("Connected Succfully")


@socketio.on('disconnect')
def disconnect():
    stopSniffer("stop")
    stopNetworkSpeed("stop")
    scapyUtils.stopArpPossingUsingScapy()
    scapyUtils.stopetterCapForWithoutMac()
    log('disconnect message')

@socketio.on_error_default  # handles all namespaces without an explicit error handler
def default_error_handler(e):
    log(e)
    pass

def log(msg: str) -> None:
    logger.debug(msg)
