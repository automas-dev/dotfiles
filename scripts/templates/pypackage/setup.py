#!/usr/bin/env python3

from setuptools import setup
import yaml

def readme():
    with open('README.md', 'r') as f:
        return f.read()

with open('setup.yml', 'r') as f:
    cfg = yaml.load(f)
    setup(long_description=readme(),
          long_description_content_type='text/markdown',
          **cfg)
