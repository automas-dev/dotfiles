#!/usr/bin/env python3


def main(args):
    print('Hello World')


if __name__ == '__main__':
    import sys
    try:
        main(sys.argv)
    except KeyboardInterrupt:
        print('Exiting!')
