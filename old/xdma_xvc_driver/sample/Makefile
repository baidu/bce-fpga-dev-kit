# d52cbaca0ef8cf4fd3d6354deb5066970fb6511d02d18d15835e6014ed847fb0
CC ?= gcc
CXX ?= g++

all: reg_write_32 reg_read_32 sample sample_user_irq

reg_write_32: reg_write_32.o fpga_cloud.o
	$(CXX) -lrt -lpthread -o $@ $^ -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

reg_read_32: reg_read_32.o fpga_cloud.o
	$(CXX) -lrt -lpthread -o $@ $^ -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

sample: sample.o fpga_cloud.o
	$(CXX) -lrt -lpthread -o $@ $^ -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

sample_user_irq: sample_user_irq.o fpga_cloud.o
	$(CXX) -lrt -lpthread -o $@ $^ -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

%.o: %.cpp
	$(CXX) -c -std=c++0x -o $@ $< -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

clean:
	rm -rf *.o reg_write_32 reg_read_32 sample sample_user_irq

