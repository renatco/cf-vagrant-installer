#!/usr/bin/python
"""
Publish cname mdns records

Avahi doesn't natively support publishing cname aliases for the
current host. 

This script is based on,
http://www.avahi.org/wiki/Examples/PythonPublishAlias
"""

import os
import os.path
import sys
import json
import time
import fcntl
import signal
import functools
from contextlib import contextmanager
import logging
import subprocess

import dbus
import avahi

from encodings.idna import ToASCII

log = logging.getLogger()

ALIAS_FILE = '/vagrant/avahi/avahi_aliases'

# Got these from /usr/include/avahi-common/defs.h
CLASS_IN = 0x01
TYPE_CNAME = 0x05
TTL = 60

published = set()

def publish_cname(cname):
    if cname in published:
        return

    if not cname.endswith(".local"):
        log.error("Not publishing a non-.local address: %s", cname)
        return

    log.info("Publishing new name: " + cname)
    published.add(cname)

    bus = dbus.SystemBus()
    server = dbus.Interface(bus.get_object(avahi.DBUS_NAME, 
                                           avahi.DBUS_PATH_SERVER),
                            avahi.DBUS_INTERFACE_SERVER)
    group = dbus.Interface(bus.get_object(avahi.DBUS_NAME, 
                                          server.EntryGroupNew()),
            avahi.DBUS_INTERFACE_ENTRY_GROUP)

    rdata = create_rr(server.GetHostNameFqdn())
    cname = encode_dns(cname)

    group.AddRecord(avahi.IF_UNSPEC, avahi.PROTO_UNSPEC, dbus.UInt32(0),
        cname, CLASS_IN, TYPE_CNAME, TTL, rdata)
    group.Commit()

def encode_dns(name):
    out = []
    for part in name.split('.'):
        if len(part) == 0: continue
        out.append(ToASCII(part))
    return '.'.join(out)

def create_rr(name):
    out = []
    for part in name.split('.'):
        if len(part) == 0: continue
        out.append(chr(len(part)))
        out.append(ToASCII(part))
    out.append('\0')
    return ''.join(out)


def reload_aliases():
    with open(ALIAS_FILE) as f:
        for line in f.readlines():
            cname = line.strip()            
            if cname.startswith('#') or cname == '':
                continue
            #if '$fqdn' in cname:
            #    cname = cname.replace('$fqdn', get_fqdn())
            publish_cname(cname)

def get_fqdn():
    hostname = open("/etc/hostname").read().strip()
    if '.' not in hostname:
        return hostname + '.local'
    else:
        return hostname

def serve_aliases():
    def handler(signum, frame):
        # as `handler` will be invoked for every change under /s/etc/,
        # we must check if the modified file was ALIAS_FILE.
        mtime = os.path.getmtime(ALIAS_FILE)
        if mtime == handler.last_mtime:
            return
        log.info("Alias file changed")
        handler.last_mtime = mtime
        reload_aliases()

    handler.last_mtime = os.path.getmtime(ALIAS_FILE)
    reload_aliases()
    signal.signal(signal.SIGIO, handler)
    fd = os.open('/vagrant/avahi', os.O_RDONLY) 
    fcntl.fcntl(fd, fcntl.F_SETSIG, 0)
    fcntl.fcntl(fd, fcntl.F_NOTIFY,
                fcntl.DN_MODIFY | fcntl.DN_CREATE | fcntl.DN_MULTISHOT)
    log.info("Infinitely waiting for %s to change.", ALIAS_FILE)
    while True:
        time.sleep(10000)

    
def main():
    log.info('init')
    try:
        hostname = open("/etc/hostname").read().strip()
        # append .local to a non-fqdn
        if '.' not in hostname:
            hostname += '.local'
        log.info("Serving " + hostname)
        publish_cname("api." + hostname)
        serve_aliases()
    except KeyboardInterrupt:
        log.info("Exiting")
    except:
        log.exception("Crashed")
	sys.exit(1)


if __name__ == '__main__':
    logging.basicConfig(
        name='avahi_publisher',
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        level=logging.DEBUG,
        stream=sys.stderr)
    main()

