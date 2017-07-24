# coding: utf-8

def handle_argument():
    '''handle the argument. '''
    import argparse

    description = 'This script is used to convert one encoding file to another encoding file.'
    epilog = """ """
    parser = argparse.ArgumentParser(prog="convert_encoding",
                                     description=description,
                                     epilog=epilog,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('infile',
                        help='The input file with path, e.g. /data/dept_dict.csv')
    parser.add_argument('--inencode', nargs='?', default='utf-8',
                        help='The input file encoding method. The default is utf-8')
    parser.add_argument('outfile',
                        help='The input file with path, e.g. /data/out_dept_dict.csv')
    parser.add_argument('--outencode', nargs='?', default='utf-8',
                        help='The input file encoding method. The default is utf-8')

    return parser


parser = handle_argument()
args = parser.parse_args()


inPath = args.infile
outPath = args.outfile

inEncode = args.inencode
outEncode = args.outencode

with open(inPath, 'r+', encoding=inEncode, errors='ignore') as fIn:
    with open(outPath, 'w+', encoding=outEncode) as fOut:
        # for line in fIn.readlines():
        #     fOut.write(line.decode(inEncode).encode(outEncode))
        fOut.writelines(fIn.readlines())
