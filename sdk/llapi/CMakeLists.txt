cmake_minimum_required(VERSION 2.6)
project(libllapi)

include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/../mgmt_tools/third_party/pciaccess/include")
link_directories("${PROJECT_SOURCE_DIR}/../mgmt_tools/third_party/pciaccess/lib")
link_libraries(pciaccess)

aux_source_directory(. SRC_LIST)
add_library(llapi STATIC ${SRC_LIST})

