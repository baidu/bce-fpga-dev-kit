cmake_minimum_required(VERSION 2.6)
project(bce_fpga_mgmt_tool)

add_subdirectory(third_party/mcap)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
    message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support.")
endif()

# The version number.
set(BCE_FPGA_MGMT_TOOL_VERSION_MAJOR 1)
set(BCE_FPGA_MGMT_TOOL_VERSION_MINOR 0)

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_SOURCE_DIR}/config.h"
)

include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/third_party/gflags/include")
include_directories("${PROJECT_SOURCE_DIR}/third_party/glog/include")
include_directories("${PROJECT_SOURCE_DIR}/third_party/pciaccess/include")
include_directories("${PROJECT_SOURCE_DIR}/third_party/jsoncpp/include")

link_directories("${PROJECT_SOURCE_DIR}/third_party/gflags/lib")
link_directories("${PROJECT_SOURCE_DIR}/third_party/glog/lib")
link_directories("${PROJECT_SOURCE_DIR}/third_party/pciutils/lib")
link_directories("${PROJECT_SOURCE_DIR}/third_party/pciaccess/lib")
link_directories("${PROJECT_SOURCE_DIR}/third_party/jsoncpp/lib")

link_libraries(glog)
link_libraries(gflags)
link_libraries(pthread)
link_libraries(z)
link_libraries(pciaccess)
link_libraries(mcap)
link_libraries(pciutils)
link_libraries(jsoncpp)

aux_source_directory(. SRC_LIST)

# add the executable
add_executable(bce_fpga_mgmt_tool ${SRC_LIST})

