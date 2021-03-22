#!/bin/bash

mkdir -p build/
ln -s build/compile_commands.json

cd build
cmake .. -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE

