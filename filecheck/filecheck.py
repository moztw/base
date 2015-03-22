#!/usr/bin/env python

from datetime import datetime
import sys

LOG_FILE = '/tmp/file_log.log'

def main():
    f = open(LOG_FILE, 'ab')
    f.write('%s - Event Triggered - %s\n' % (datetime.now().strftime("%Y-%m-%d %H:%M:%S"), ", ".join(sys.argv)))
    f.close

if __name__ == '__main__':
    main()
