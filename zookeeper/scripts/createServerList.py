#!/usr/bin/python
import argparse

parser=argparse.ArgumentParser(prog='serverList')
parser.add_argument('serverName', help='input the zookeeper server general name')
parser.add_argument('serverNum', type=int, help='input the zookeeper servers number')
parser.add_argument('zkMode', nargs='?', help='input the zookeeper server configuration mode, standalone or replicated')
args=parser.parse_args()

def main():
    if args.zkMode is not None and args.zkMode != "standalone":
        serverName=args.serverName if args.serverName is not None else "zoo"
        num=args.serverNum if args.serverNum is not None else 0
        serverList = [ "server.{0}={1}{0}:2888:3888".format(i,serverName) for i in range(1,num+1) ]
        for item in serverList:print item

if __name__ == '__main__':
    main()
