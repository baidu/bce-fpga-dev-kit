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

   localparam TEST_REG1_ADDR = 16'd0;
   localparam TEST_REG2_ADDR = 16'd4;
   localparam TEST_REG3_ADDR = 16'd8;
   localparam TEST_REG4_ADDR = 16'd12;
   localparam MAX_VALUE      = 32'h80000000;

   card_sim card_sim();

   reg  [31:0]  reg1_data_r;
   reg  [31:0]  reg2_data_r;
   reg  [31:0]  reg3_data_r;
   reg  [31:0]  reg3_expect_data_r;
   reg  [7:0]   cmp_char1;
   reg  [7:0]   cmp_char2;
   reg  [63:0]  cmp_addr1;
   reg  [63:0]  cmp_addr2;
   reg  [63:0]  init_hostmem_addr;
   reg  [31:0]  init_hostmem_data;
   reg          test_DDR;

   `ifdef USE_DDR
   initial begin
      test_DDR = 1'b1;
   end
   `else
   initial begin
      test_DDR = 1'b0;
   end
   `endif

   initial begin
      #1000;
      //test reg
      reg1_data_r = {$random} % MAX_VALUE;
      reg2_data_r = {$random} % MAX_VALUE;
      reg3_expect_data_r = reg1_data_r + reg2_data_r;
      card_sim.sp_sim.axi_l_wr(TEST_REG1_ADDR,reg1_data_r,4'hf);
      card_sim.sp_sim.axi_l_wr(TEST_REG2_ADDR,reg2_data_r,4'hf);
      #100;
      card_sim.sp_sim.axi_l_rd(TEST_REG3_ADDR,reg3_data_r);
      if (reg3_expect_data_r != reg3_data_r) begin
         $display ("%g Test fail", $time);
         $finish;
      end

      //test memory
      if (test_DDR) begin
         init_hostmem_addr = 'd0;
         init_hostmem_data = 'd0;
         repeat (1024) begin
            card_sim.sp_sim.host_mem_wr(init_hostmem_addr,
                        {init_hostmem_data+'d7,
                         init_hostmem_data+'d6,
                         init_hostmem_data+'d5,
                         init_hostmem_data+'d4,
                         init_hostmem_data+'d3,
                         init_hostmem_data+'d2,
                         init_hostmem_data+'d1,
                         init_hostmem_data},
                         {(32){1'b1}}
                        );
            init_hostmem_addr = init_hostmem_addr + 'd32;
            init_hostmem_data = init_hostmem_data + 'd8;
         end
         card_sim.sp_sim.dma_op_cfg('d0,'d0,'d0,'d8192,0);
         card_sim.sp_sim.dma_op_start('d0);
         wait (card_sim.sp_sim.dma_status == 4'b0);
         $display ("%g 1st DMA operation end", $time);
         card_sim.sp_sim.dma_op_cfg('d0,'d0,'d32768,'d8192,1);
         card_sim.sp_sim.dma_op_start('d0);
         wait (card_sim.sp_sim.dma_status == 4'b0);
         $display ("%g 2nd DMA operation end", $time);
         $display ("%g compare data start", $time);
         cmp_addr1 = 'd0;
         cmp_addr2 = 'd32768;
         repeat(8192) begin
            card_sim.sp_sim.host_mem_rd_char(cmp_addr1,cmp_char1);
            card_sim.sp_sim.host_mem_rd_char(cmp_addr2,cmp_char2);
            if (cmp_char1 != cmp_char2) begin
               $display ("%g Host Mem read char error", $time);
               $finish;
            end
            cmp_addr1 = cmp_addr1 + 'd1;
            cmp_addr2 = cmp_addr2 + 'd1;
         end
      end
      $display ("%g Test pass", $time);
      $finish;
   end

endmodule
