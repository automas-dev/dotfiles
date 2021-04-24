#!/bin/bash

cmake -S . -B build -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE

ln -s build/compile_commands.json

