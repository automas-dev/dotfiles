cmake_minimum_required(VERSION 3.15)
project(project VERSION 1.0.0 LANGUAGES CXX)

find_package(fmt REQUIRED)

add_executable(app main.cpp)
target_compile_features(app PRIVATE cxx_std_17)

target_link_libraries(app fmt::fmt)

