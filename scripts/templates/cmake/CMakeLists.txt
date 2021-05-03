cmake_minimum_required(VERSION 3.15...3.20)
project(project VERSION 0.0.0 LANGUAGES CXX)

find_package(fmt REQUIRED)

set(TARGET app)
add_executable(${TARGET} main.cpp)
target_compile_features(${TARGET} PRIVATE cxx_std_17)

target_link_libraries(${TARGET} PRIVATE fmt::fmt)

