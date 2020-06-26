#!/usr/bin/env python3

import os
from os import path
import tarfile

DEFAULT_TEMPLATE_DIR = '~/.scripts/templates/'


def parse_lang(args):
    l = args.LANGUAGE.lower()
    if l == 'c++' or l == 'cpp' or l == 'cxx':
        return 'cpp'
    elif l == 'py' or l == 'python' or l == 'python3':
        return 'py'
    else:
        return l


def get_template(args, template_dir=DEFAULT_TEMPLATE_DIR):
    if args.test:
        filename = parse_lang(args) + 'test'
    elif args.gtest:
        filename = parser_lang(args) + 'gtest'
    elif args.lib:
        filename = parse_lang(args) + args.lib
    else:
        filename = parse_lang(args)

    filename += '.tar'
    tar_path = path.join(template_dir, filename)
    return path.expanduser(tar_path)


def sanitise_dir(directory):
    '''Make an absolute path, normalize, and then make relative again'''
    return path.normpath('/' + directory).lstrip('/')


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(
        description='Make a new project, part of the mk tools series')
    parser.add_argument('-l', '--lib', choices=['static', 'shared'],
                        help='Make the project a library')
    parser.add_argument('-t', '--test', action='store_true',
                        help='Make the project with simple tests')
    parser.add_argument('-g', '--gtest', action='store_true',
                        help='Make the project with google tests')
    parser.add_argument('LANGUAGE', type=str,
                        help='The language the project will be using')
    parser.add_argument('NAME', type=str, help='The name for the new project')

    args = parser.parse_args()
    #args = parser.parse_args(['-h'])
    #args = parser.parse_args(['c', 'testprj'])

    archive = get_template(args)
    if not path.isfile(archive):
        pfmt = args.LANGUAGE
        if args.test:
            pfmt += ' test'
        elif args.gtest:
            pfmt += ' google test'
        elif args.lib:
            pfmt += ' ' + args.lib
        parser.error('There is no template for a {} project'.format(pfmt))

    project_dir = sanitise_dir(args.NAME)
    if not path.isdir(project_dir):
        os.mkdir(project_dir)

    tar = tarfile.open(archive)
    tar.extractall(project_dir)
    tar.close()
