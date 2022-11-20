from flask import Flask
from flask_socketio import SocketIO
import logging
from os import getenv

# async_mode = None

# if async_mode is None:
#     try:
#         import eventlet
#         async_mode = 'eventlet'
#     except ImportError:
#         pass

#     if async_mode is None:
#         try:
#             from gevent import monkey
#             async_mode = 'gevent'
#         except ImportError:
#             pass

#     if async_mode is None:
#         async_mode = 'threading'

#     print('async_mode is ' + async_mode)

# if async_mode == 'eventlet':
#     import eventlet
#     eventlet.monkey_patch()
# elif async_mode == 'gevent':
#     from gevent import monkey
#     monkey.patch_all()

logging.getLogger(__name__).setLevel(logging.DEBUG)
logging.getLogger('flask_socketio').setLevel(logging.DEBUG)

app = Flask(__name__)

app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app,engineio_logger=False,async_handlers=True)

logger=app.logger

from .scapy_util import scapyUtil

scapyUtils = scapyUtil.scapyUtil()

from . import rest, sockets