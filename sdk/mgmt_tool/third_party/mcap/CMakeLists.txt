cmake_minimum_required(VERSION 2.6)
project(libmcap)

include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/../pciutils/include")
include_directories("${PROJECT_SOURCE_DIR}/../pciutils/lib")
include_directories("${PROJECT_SOURCE_DIR}/../pciutils")

aux_source_directory(. SRC_LIST)
add_library(mcap STATIC ${SRC_LIST})

