# d52cbaca0ef8cf4fd3d6354deb5066970fb6511d02d18d15835e6014ed847fb0
CC ?= gcc
CXX ?= g++

all: sample

sample: sample.o fpga_cloud.o
	$(CXX) -lrt -lpthread -o $@ $^ -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

%.o: %.cpp
	$(CXX) -c -std=c++0x -o $@ $< -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

clean:
	rm -rf *.o sample

