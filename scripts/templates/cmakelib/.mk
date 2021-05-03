#!/bin/bash

cmake -S . -B build -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE -DCMAKE_INSTALL_PREFIX=install

ln -s build/compile_commands.json

