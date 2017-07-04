/*******************************************************************************
Vendor: Xilinx 
Associated Filename: example.cpp
Purpose: Example to create an AXI4 master interface in Vivado HLS
Revision History: February 13, 2012 - initial release
                                                
*******************************************************************************
#-  (c) Copyright 2011-2016 Xilinx, Inc. All rights reserved.
#-
#-  This file contains confidential and proprietary information
#-  of Xilinx, Inc. and is protected under U.S. and
#-  international copyright and other intellectual property
#-  laws.
#-
#-  DISCLAIMER
#-  This disclaimer is not a license and does not grant any
#-  rights to the materials distributed herewith. Except as
#-  otherwise provided in a valid license issued to you by
#-  Xilinx, and to the maximum extent permitted by applicable
#-  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#-  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#-  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#-  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#-  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#-  (2) Xilinx shall not be liable (whether in contract or tort,
#-  including negligence, or under any other theory of
#-  liability) for any loss or damage of any kind or nature
#-  related to, arising under or in connection with these
#-  materials, including for any direct, or any indirect,
#-  special, incidental, or consequential loss or damage
#-  (including loss of data, profits, goodwill, or any type of
#-  loss or damage suffered as a result of any action brought
#-  by a third party) even if such damage or loss was
#-  reasonably foreseeable or Xilinx had been advised of the
#-  possibility of the same.
#-
#-  CRITICAL APPLICATIONS
#-  Xilinx products are not designed or intended to be fail-
#-  safe, or for use in any application requiring fail-safe
#-  performance, such as life-support or safety devices or
#-  systems, Class III medical devices, nuclear facilities,
#-  applications related to the deployment of airbags, or any
#-  other applications that could lead to death, personal
#-  injury, or severe property or environmental damage
#-  (individually and collectively, "Critical
#-  Applications"). Customer assumes the sole risk and
#-  liability of any use of Xilinx products in Critical
#-  Applications, subject only to applicable laws and
#-  regulations governing limitations on product liability.
#-
#-  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#-  PART OF THIS FILE AT ALL TIMES. 
#- ************************************************************************


This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer assumes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/

/*
 * This file contains an example for creating an AXI4-master interface in Vivado HLS
 */
				      
#include <stdio.h>
#include <string.h>
#include "example.h"
#define SEG_LEN_MAX 256

void example(volatile data_t *a, ap_uint<16> n, int a_addr, int b_addr, int c_addr){
#pragma HLS INTERFACE ap_vld port=a_addr
#pragma HLS INTERFACE ap_vld port=b_addr
#pragma HLS INTERFACE ap_vld port=c_addr
#pragma HLS INTERFACE ap_vld port=n
#pragma HLS INTERFACE m_axi port=a depth=512
  
  int i,j, s;
  data_t buff_a[SEG_LEN_MAX];
  data_t buff_b[SEG_LEN_MAX];
  data_t buff[SEG_LEN_MAX];
  int tmp_int_a, tmp_int_b;
  ap_int<32> tmp_data_t[8];
  float tmp_float;
  
  ap_uint<16> segment = n / SEG_LEN_MAX + (n % SEG_LEN_MAX != 0);
  ap_uint<16> segment_len;
  int curr_addr_a = a_addr, curr_addr_b = b_addr, curr_addr_c = c_addr;
  for(s = 0 ; s < segment; s++){
	  segment_len = (s == (segment-1)) ? (n % ap_uint<16>(SEG_LEN_MAX)) : ap_uint<16>(SEG_LEN_MAX);
	    //memcpy creates a burst access to memory
	    //multiple calls of memcpy ***cannot*** be pipelined and will be scheduled sequentially
	    //memcpy requires a local buffer to store the results of the memory transaction
	    memcpy(buff_a,(const data_t*)a+curr_addr_a,segment_len*sizeof(data_t));
	    memcpy(buff_b,(const data_t*)a+curr_addr_b,segment_len*sizeof(data_t));

	    for_loop_N: for(i=0; i < segment_len; i++){
#pragma HLS PIPELINE
	  	  for_loop_J: for(j=0 ; j<8 ;j++){
	  		  tmp_int_a = buff_a[i](32*j+31,32*j);
	  		  tmp_int_b = buff_b[i](32*j+31,32*j);
	  		  tmp_float = *(float *)(&(tmp_int_a)) + *(float *)(&(tmp_int_b));
	  		  tmp_data_t[j] = *(int *)&tmp_float;
	  	  }
	  	  buff[i]=(tmp_data_t[7],tmp_data_t[6],tmp_data_t[5],tmp_data_t[4],
	  			  tmp_data_t[3],tmp_data_t[2],tmp_data_t[1],tmp_data_t[0]);
	    }

	    memcpy((data_t *)a+curr_addr_c,buff,segment_len*sizeof(data_t));
	    curr_addr_a += SEG_LEN_MAX;
	    curr_addr_b += SEG_LEN_MAX;
	    curr_addr_c += SEG_LEN_MAX;
  }
  
}


// XSIexample_label0:P watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
