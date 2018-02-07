#!/usr/bin/python
import argparse

parser = argparse.ArgumentParser(prog='serverList')
parser.add_argument('serverName', help='input the zookeeper server general name')
parser.add_argument('serverNum', type=int, help='input the zookeeper servers number')
parser.add_argument('--zkMode', nargs='?', help='input the zookeeper configuration mode, standalone or replicated')
parser.add_argument('--serviceName', nargs='?', help='input the zookeeper service name customized by k8s')
args = parser.parse_args()


def main():
    if args.zkMode is not None and args.zkMode != "standalone":
        serverName = args.serverName if args.serverName is not None else "zoo"
        num = args.serverNum if args.serverNum is not None else 0
        if (args.serviceName is not None and args.serviceName.strip() != ""):
            serviceName = ".{0}".format(args.serviceName.strip())
        else:
            serviceName = ""
        serverList = ["server.{0}={1}-{0}{2}:2888:3888".format(i, serverName, serviceName) for i in range(0, num)]
        for item in serverList:
            print item


if __name__ == '__main__':
    main()
