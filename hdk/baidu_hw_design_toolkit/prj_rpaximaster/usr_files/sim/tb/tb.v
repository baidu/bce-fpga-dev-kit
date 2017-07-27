//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: card_sim.v
//    Data last Modified:
//    Data Created:June. 7th, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: simulate for card of FPGA cloud.
//
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb ();

   localparam DATA_WIDTH = 256;
   localparam ADDR_WIDTH = 64;
   localparam MASK_WIDTH = DATA_WIDTH/8;
   localparam ID_WIDTH   = 4;
   localparam ADDR_ALIGN_BITS = $clog2(MASK_WIDTH);

   localparam START_REG_ADDR     = 16'h00;
   localparam SRC_LSB_REG_ADDR   = 16'h04;
   localparam SRC_MSB_REG_ADDR   = 16'h08;
   localparam DST_LSB_REG_ADDR   = 16'h0c;
   localparam DST_MSB_REG_ADDR   = 16'h10;
   localparam LEN_REG_ADDR       = 16'h14;
   localparam DIRECTION_REG_ADDR = 16'h18; //0 for c2h, 1 for h2c

   localparam HOST_BASEADDR  = 64'h0;
   localparam CARD_BASEADDR  = 64'h0;

   card_sim card_sim();

   reg [63:0]  init_hostmem_addr;
   reg [31:0]  init_hostmem_data;
   reg [31:0]  reg_rddata;
   reg [63:0]  dma_src_addr;
   reg [63:0]  dma_dst_addr;
   reg [31:0]  dma_len;
   reg [31:0]  dma_len_plus;

   reg [7:0]   chk_data1;
   reg [7:0]   chk_data2;
   reg [63:0]  chk_addr1;
   reg [63:0]  chk_addr2;

   initial begin
      //init host mem
      init_hostmem_data = 'd0;
      init_hostmem_addr = 'd0;

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

      repeat (1024*4) begin
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

      dma_src_addr = 0;
      dma_dst_addr = 0;
      dma_len = {$random}%65536;
      dma_len_plus = dma_len + 'd32;
      chk_addr1 = dma_src_addr;

      //set dma src addr & dst addr
      card_sim.sp_sim.axi_l_wr(SRC_LSB_REG_ADDR,dma_src_addr[31:0],4'hf);
      card_sim.sp_sim.axi_l_wr(SRC_MSB_REG_ADDR,dma_src_addr[63:32],4'hf);
      card_sim.sp_sim.axi_l_wr(DST_LSB_REG_ADDR,dma_dst_addr[31:0],4'hf);
      card_sim.sp_sim.axi_l_wr(DST_MSB_REG_ADDR,dma_dst_addr[63:32],4'hf);

      //set dma len and start dma
      card_sim.sp_sim.axi_l_wr(LEN_REG_ADDR,dma_len,4'hf);
      card_sim.sp_sim.axi_l_wr(DIRECTION_REG_ADDR,32'h1,4'hf);
      card_sim.sp_sim.axi_l_wr(START_REG_ADDR,1'b1,4'hf);

      //wait for dma opertion end
      card_sim.sp_sim.interrupt_wait('d0);

      //new dma configuration
      dma_src_addr = dma_dst_addr;
      dma_dst_addr = chk_addr1 + {dma_len_plus[31:5],5'b0};
      chk_addr2    = dma_dst_addr;

      //set dma src addr & dst addr
      card_sim.sp_sim.axi_l_wr(SRC_LSB_REG_ADDR,dma_src_addr[31:0],4'hf);
      card_sim.sp_sim.axi_l_wr(SRC_MSB_REG_ADDR,dma_src_addr[63:32],4'hf);
      card_sim.sp_sim.axi_l_wr(DST_LSB_REG_ADDR,dma_dst_addr[31:0],4'hf);
      card_sim.sp_sim.axi_l_wr(DST_MSB_REG_ADDR,dma_dst_addr[63:32],4'hf);

      //set dma len and start dma
      card_sim.sp_sim.axi_l_wr(LEN_REG_ADDR,dma_len,4'hf);
      card_sim.sp_sim.axi_l_wr(DIRECTION_REG_ADDR,32'h0,4'hf);
      card_sim.sp_sim.axi_l_wr(START_REG_ADDR,1'b1,4'hf);

      //wait for dma opertion end
      card_sim.sp_sim.interrupt_wait('d0);

      //check result
      repeat (dma_len) begin
         card_sim.sp_sim.host_mem_rd_char(chk_addr1,chk_data1);
         card_sim.sp_sim.host_mem_rd_char(chk_addr2,chk_data2);
         $display ("%g chk_data1 is %h, chk_data2 is %h", $time,chk_data1,chk_data2);
         if (chk_data1 != chk_data2) begin
            $display ("%g Test fail", $time);
            $finish;
         end
         chk_addr1 = chk_addr1 + 'd1;
         chk_addr2 = chk_addr2 + 'd1;
      end
      $display ("%g Test pass", $time);
      $finish;
   end

endmodule
