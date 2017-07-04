/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
`timescale 1ns / 1ps

module tb ();

   localparam DATA_WIDTH = 256;
   localparam ADDR_WIDTH = 64;
   localparam MASK_WIDTH = DATA_WIDTH/8;
   localparam ID_WIDTH   = 4;
   localparam ADDR_ALIGN_BITS = $clog2(MASK_WIDTH);

   localparam START_CMD_REG  = 16'h0;
   localparam A_BASEADDR_REG = 16'h4;
   localparam B_BASEADDR_REG = 16'h8;
   localparam C_BASEADDR_REG = 16'hc;
   localparam VECTOR_LEN_REG = 16'h10;

   localparam VECTOR_LEN_BYTES = 32'd256;
   localparam VECTOR_LEN_NUMS  = VECTOR_LEN_BYTES/4;
   localparam VECTOR_LEN_WORDS = VECTOR_LEN_BYTES/MASK_WIDTH;

   localparam HOST_A_BASEADDR = 64'h0;
   localparam HOST_B_BASEADDR = HOST_A_BASEADDR + VECTOR_LEN_BYTES;
   localparam HOST_RESULT_BASEADDR = HOST_B_BASEADDR + VECTOR_LEN_BYTES;

   localparam CARD_A_BASEADDR = HOST_A_BASEADDR + 32'h80000000;
   localparam CARD_B_BASEADDR = CARD_A_BASEADDR + VECTOR_LEN_BYTES;
   localparam CARD_C_BASEADDR = CARD_B_BASEADDR + VECTOR_LEN_BYTES;;

   card_sim card_sim();

   reg  [255:0] vector_a;
   reg  [255:0] vector_b;
   reg  [255:0] expect_result;
   reg  [255:0] calc_result;
   reg  [63:0]  host_a_addr;
   reg  [63:0]  host_b_addr;
   reg  [63:0]  host_result_addr;

   reg  [0:0]   dma_stats;

   initial begin
      //inital vector a {1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0}
      vector_a = {32'h3F800000, 32'h40000000, 32'h40400000, 32'h40800000, 32'h40A00000, 32'h40C00000, 32'h40E00000, 32'h41000000};
      //inital vector b {8.0,7.0,6.0,5.0,4.0,3.0,2.0,1.0}
      vector_b = {32'h41000000, 32'h40E00000, 32'h40C00000, 32'h40A00000, 32'h40800000, 32'h40400000, 32'h40000000, 32'h3F800000};
      //expect result for a+b
      expect_result = {(8){32'h41100000}};

      #5000;
      //write ddr for removing warning display
      card_sim.sp_sim.axi_wr(64'h0,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h20,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h80000000,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h80000020,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h100000000,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h100000020,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h180000000,256'b0,4'd5);
      card_sim.sp_sim.axi_wr(64'h180000020,256'b0,4'd5);

      #1000;
      //init host mem
      host_a_addr = HOST_A_BASEADDR;
      host_b_addr = HOST_B_BASEADDR;
      host_result_addr = HOST_RESULT_BASEADDR;
      repeat (VECTOR_LEN_WORDS) begin
         card_sim.sp_sim.host_mem_wr(host_a_addr,vector_a,32'hffffffff);
         card_sim.sp_sim.host_mem_wr(host_b_addr,vector_b,32'hffffffff);
         card_sim.sp_sim.host_mem_wr(host_result_addr,256'd0,32'hffffffff);
         host_a_addr = host_a_addr + MASK_WIDTH;
         host_b_addr = host_b_addr + MASK_WIDTH;
         host_result_addr = host_result_addr + MASK_WIDTH;
      end

      //start dma operation for host2card
      card_sim.sp_sim.dma_op_cfg('d0,HOST_A_BASEADDR,CARD_A_BASEADDR,VECTOR_LEN_BYTES,0);
      card_sim.sp_sim.dma_op_cfg('d1,HOST_B_BASEADDR,CARD_B_BASEADDR,VECTOR_LEN_BYTES,0);
      card_sim.sp_sim.dma_op_start('d0);
      card_sim.sp_sim.dma_op_start('d1);

      //wait for dma opertion end
      wait (card_sim.sp_sim.dma_status == 4'b0);

      //configure vector add parameter
      card_sim.sp_sim.axi_l_wr(A_BASEADDR_REG,CARD_A_BASEADDR,4'hf);
      card_sim.sp_sim.axi_l_wr(B_BASEADDR_REG,CARD_B_BASEADDR,4'hf);
      card_sim.sp_sim.axi_l_wr(C_BASEADDR_REG,CARD_C_BASEADDR,4'hf);
      card_sim.sp_sim.axi_l_wr(VECTOR_LEN_REG,VECTOR_LEN_NUMS,4'hf);

      //start vector add operation
      card_sim.sp_sim.axi_l_wr(START_CMD_REG,32'd0,4'hf);

      //wait for vector add end
      card_sim.sp_sim.interrupt_wait('d0);

      //start dma operation for card2host
      card_sim.sp_sim.dma_op_cfg('d0,CARD_C_BASEADDR,HOST_RESULT_BASEADDR,VECTOR_LEN_BYTES,1);
      card_sim.sp_sim.dma_op_start('d0);

      //wait for dma opertion end
      wait (card_sim.sp_sim.dma_status == 4'b0);

      //check result
      host_result_addr = HOST_RESULT_BASEADDR;
      repeat (VECTOR_LEN_WORDS) begin
         card_sim.sp_sim.host_mem_rd(host_result_addr,calc_result);
         if (calc_result != expect_result) begin
            $display ("%g Test fail", $time);
         end
         host_result_addr = host_result_addr + MASK_WIDTH;
      end
      $display ("%g Test pass", $time);
      $finish;
   end

endmodule
