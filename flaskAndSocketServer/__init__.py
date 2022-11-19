from flask import Flask
from flask_socketio import SocketIO
import logging
from os import getenv

# if getenv('FLASK_DEBUG') == 'development':
logging.getLogger(__name__).setLevel(logging.DEBUG)
logging.getLogger('flask_socketio').setLevel(logging.DEBUG)
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

logger=app.logger

from .scapy_util import scapyUtil

scapyUtils = scapyUtil.scapyUtil()

from . import rest, sockets