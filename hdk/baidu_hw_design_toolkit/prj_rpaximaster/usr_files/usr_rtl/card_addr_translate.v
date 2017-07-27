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
module card_addr_translate #(
   parameter DATA_WIDTH = 256,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4
)(
   input                    clk,
   input                    rst,

   //receive from sp
   // AXI slave AW channel
   input  [ADDR_WIDTH-1:0]  s_axi_araddr,
   input  [1:0]             s_axi_arburst,
   input  [3:0]             s_axi_arcache,
   input  [ID_WIDTH-1:0]    s_axi_arid,
   input  [7:0]             s_axi_arlen,
   input                    s_axi_arlock,
   input  [2:0]             s_axi_arprot,
   input  [3:0]             s_axi_arqos,
   input  [3:0]             s_axi_arregion,
   output                   s_axi_arready,
   input  [2:0]             s_axi_arsize,
   input                    s_axi_arvalid,
   // AXI slave AR channel
   input  [ADDR_WIDTH-1:0]  s_axi_awaddr,
   input  [1:0]             s_axi_awburst,
   input  [3:0]             s_axi_awcache,
   input  [ID_WIDTH-1:0]    s_axi_awid,
   input  [7:0]             s_axi_awlen,
   input                    s_axi_awlock,
   input  [2:0]             s_axi_awprot,
   input  [3:0]             s_axi_awqos,
   input  [3:0]             s_axi_awregion,
   output                   s_axi_awready,
   input  [2:0]             s_axi_awsize,
   input                    s_axi_awvalid,
   // AXI slave B channel
   output [ID_WIDTH-1:0]    s_axi_bid,
   input                    s_axi_bready,
   output [1:0]             s_axi_bresp,
   output                   s_axi_bvalid,
   // AXI slave R channel
   output [DATA_WIDTH-1:0]  s_axi_rdata,
   output [ID_WIDTH-1:0]    s_axi_rid,
   output                   s_axi_rlast,
   input                    s_axi_rready,
   output [1:0]             s_axi_rresp,
   output                   s_axi_rvalid,
   // AXI slave W channel
   input  [DATA_WIDTH-1:0]  s_axi_wdata,
   input                    s_axi_wlast,
   output                   s_axi_wready,
   input  [MASK_WIDTH-1:0]  s_axi_wstrb,
   input                    s_axi_wvalid,

   // transfer to axi interconnect
   // AXI Master AW channel
   output [ADDR_WIDTH-1:0]  m_axi_araddr,
   output [1:0]             m_axi_arburst,
   output [3:0]             m_axi_arcache,
   output [ID_WIDTH-1:0]    m_axi_arid,
   output [7:0]             m_axi_arlen,
   output                   m_axi_arlock,
   output [2:0]             m_axi_arprot,
   output [3:0]             m_axi_arqos,
   output [3:0]             m_axi_arregion,
   input                    m_axi_arready,
   output [2:0]             m_axi_arsize,
   output                   m_axi_arvalid,
   // AXI Master AR channel
   output [ADDR_WIDTH-1:0]  m_axi_awaddr,
   output [1:0]             m_axi_awburst,
   output [3:0]             m_axi_awcache,
   output [ID_WIDTH-1:0]    m_axi_awid,
   output [7:0]             m_axi_awlen,
   output                   m_axi_awlock,
   output [2:0]             m_axi_awprot,
   output [3:0]             m_axi_awqos,
   output [3:0]             m_axi_awregion,
   input                    m_axi_awready,
   output [2:0]             m_axi_awsize,
   output                   m_axi_awvalid,
   // AXI Master B channel
   input  [ID_WIDTH-1:0]    m_axi_bid,
   output                   m_axi_bready,
   input  [1:0]             m_axi_bresp,
   input                    m_axi_bvalid,
   // AXI Master R channel
   input  [DATA_WIDTH-1:0]  m_axi_rdata,
   input  [ID_WIDTH-1:0]    m_axi_rid,
   input                    m_axi_rlast,
   output                   m_axi_rready,
   input  [1:0]             m_axi_rresp,
   input                    m_axi_rvalid,
   // AXI Master W channel
   output [DATA_WIDTH-1:0]  m_axi_wdata,
   output                   m_axi_wlast,
   input                    m_axi_wready,
   output [MASK_WIDTH-1:0]  m_axi_wstrb,
   output                   m_axi_wvalid,

   // recevie from SP
   // AXI Lite slave AW channel
   input  [15:0]            s_axi_lite_araddr,
   input  [2:0]             s_axi_lite_arprot,
   output                   s_axi_lite_arready,
   input                    s_axi_lite_arvalid,
   // AXI Lite slave AR channel
   input  [15:0]            s_axi_lite_awaddr,
   input  [2:0]             s_axi_lite_awprot,
   output                   s_axi_lite_awready,
   input                    s_axi_lite_awvalid,
   // AXI Lite slave B channel
   input                    s_axi_lite_bready,
   output [1:0]             s_axi_lite_bresp,
   output                   s_axi_lite_bvalid,
   // AXI Lite slave R channel
   output [31:0]            s_axi_lite_rdata,
   input                    s_axi_lite_rready,
   output [1:0]             s_axi_lite_rresp,
   output                   s_axi_lite_rvalid,
   // AXI Lite slave W channel
   input  [31:0]            s_axi_lite_wdata,
   output                   s_axi_lite_wready,
   input  [3:0]             s_axi_lite_wstrb,
   input                    s_axi_lite_wvalid,

   // control axi cdma
   // AXI Lite master AW channel
   output [15:0]            m_axi_lite_araddr,
   output [2:0]             m_axi_lite_arprot,
   input                    m_axi_lite_arready,
   output                   m_axi_lite_arvalid,
   // AXI Lite master AR channel
   output [15:0]            m_axi_lite_awaddr,
   output [2:0]             m_axi_lite_awprot,
   input                    m_axi_lite_awready,
   output                   m_axi_lite_awvalid,
   // AXI Lite master B channel
   output                   m_axi_lite_bready,
   input  [1:0]             m_axi_lite_bresp,
   input                    m_axi_lite_bvalid,
   // AXI Lite master R channel
   input  [31:0]            m_axi_lite_rdata,
   output                   m_axi_lite_rready,
   input  [1:0]             m_axi_lite_rresp,
   input                    m_axi_lite_rvalid,
   // AXI Lite master W channel
   output [31:0]            m_axi_lite_wdata,
   input                    m_axi_lite_wready,
   output [3:0]             m_axi_lite_wstrb,
   output                   m_axi_lite_wvalid,

   output [8:0]             dbg_bus,
   input  [15:0]            usr_irq_ack,
   output [15:0]            usr_irq_req,
   input                    axi_cdma_interrupt
);

   localparam CARD_ADDRESS_BASE = 40;
// pass-through AXI signal, only change addr
   assign m_axi_araddr      = s_axi_araddr | (1'b1 << CARD_ADDRESS_BASE);
   assign m_axi_arburst     = s_axi_arburst;
   assign m_axi_arcache     = s_axi_arcache;
   assign m_axi_arid        = s_axi_arid;
   assign m_axi_arlen       = s_axi_arlen;
   assign m_axi_arlock      = s_axi_arlock;
   assign m_axi_arprot      = s_axi_arprot;
   assign m_axi_arqos       = s_axi_arqos;
   assign m_axi_arregion    = s_axi_arregion;
   assign m_axi_arsize      = s_axi_arsize;
   assign m_axi_arvalid     = s_axi_arvalid;
   assign m_axi_awaddr      = s_axi_awaddr | (1'b1 << CARD_ADDRESS_BASE);
   assign m_axi_awburst     = s_axi_awburst;
   assign m_axi_awcache     = s_axi_awcache;
   assign m_axi_awid        = s_axi_awid;
   assign m_axi_awlen       = s_axi_awlen;
   assign m_axi_awlock      = s_axi_awlock;
   assign m_axi_awprot      = s_axi_awprot;
   assign m_axi_awqos       = s_axi_awqos;
   assign m_axi_awregion    = s_axi_awregion;
   assign m_axi_awsize      = s_axi_awsize;
   assign m_axi_awvalid     = s_axi_awvalid;
   assign m_axi_bready      = s_axi_bready;
   assign m_axi_rready      = s_axi_rready;
   assign m_axi_wdata       = s_axi_wdata;
   assign m_axi_wlast       = s_axi_wlast;
   assign m_axi_wstrb       = s_axi_wstrb;
   assign m_axi_wvalid      = s_axi_wvalid;

   assign s_axi_arready     = m_axi_arready;
   assign s_axi_awready     = m_axi_awready;
   assign s_axi_bid         = m_axi_bid;
   assign s_axi_bresp       = m_axi_bresp;
   assign s_axi_bvalid      = m_axi_bvalid;
   assign s_axi_rdata       = m_axi_rdata;
   assign s_axi_rid         = m_axi_rid;
   assign s_axi_rlast       = m_axi_rlast;
   assign s_axi_rresp       = m_axi_rresp;
   assign s_axi_rvalid      = m_axi_rvalid;
   assign s_axi_wready      = m_axi_wready;

// axi-lite reg
   localparam START_REG_ADDR     = 8'h00;
   localparam SRC_LSB_REG_ADDR   = 8'h04;
   localparam SRC_MSB_REG_ADDR   = 8'h08;
   localparam DST_LSB_REG_ADDR   = 8'h0c;
   localparam DST_MSB_REG_ADDR   = 8'h10;
   localparam LEN_REG_ADDR       = 8'h14;
   localparam DIRECTION_REG_ADDR = 8'h18; //0 for c2h, 1 for h2c

   reg [31:0] src_lsb_r;
   reg [31:0] src_msb_r;
   reg [31:0] dst_lsb_r;
   reg [31:0] dst_msb_r;
   reg [31:0] len_r;
   reg        direction_r;

   // axi lite read channel
   reg [31:0] axi_lite_rd_data_r;
   reg        axi_lite_rd_data_vld_r;

   assign s_axi_lite_arready = 1'b1;
   assign s_axi_lite_rresp   = 2'b0;
   assign s_axi_lite_rvalid  = axi_lite_rd_data_vld_r;
   assign s_axi_lite_rdata   = axi_lite_rd_data_r;

   always @(posedge clk) begin
      axi_lite_rd_data_vld_r <= s_axi_lite_arvalid;
      axi_lite_rd_data_r     <= (s_axi_lite_araddr == SRC_LSB_REG_ADDR)   ? src_lsb_r :
                                (s_axi_lite_araddr == SRC_MSB_REG_ADDR)   ? src_msb_r :
                                (s_axi_lite_araddr == DST_LSB_REG_ADDR)   ? dst_lsb_r :
                                (s_axi_lite_araddr == DST_MSB_REG_ADDR)   ? dst_msb_r :
                                (s_axi_lite_araddr == LEN_REG_ADDR)       ? len_r :
                                (s_axi_lite_araddr == DIRECTION_REG_ADDR) ? direction_r :
                                'd0;
   end

   // axi lite write channel
   reg  w_rdy_r;
   reg  b_vld_r;

   assign s_axi_lite_awready = w_rdy_r;
   assign s_axi_lite_wready  = w_rdy_r;
   assign s_axi_lite_bvalid  = b_vld_r;
   assign s_axi_lite_bresp   = 2'b0;

   always @(posedge clk) begin
      if (rst) begin
         w_rdy_r <= 1'b0;
      end
      else if (w_rdy_r) begin
         w_rdy_r <= 1'b0;
      end
      else if (~b_vld_r && s_axi_lite_awvalid && s_axi_lite_wvalid) begin
         w_rdy_r <= 1'b1;
      end
   end

   always @(posedge clk) begin
      if (rst) begin
         b_vld_r <= 1'b0;
      end
      else if (b_vld_r && s_axi_lite_bready) begin
         b_vld_r <= 1'b0;
      end
      else if (s_axi_lite_awvalid && s_axi_lite_awready) begin
         b_vld_r <= 1'b1;
      end
   end

   always @(posedge clk) begin
      if(s_axi_lite_awvalid && s_axi_lite_awready) begin
         src_lsb_r   <= (s_axi_lite_awaddr[7:0] == SRC_LSB_REG_ADDR)   ? s_axi_lite_wdata    : src_lsb_r   ;
         dst_lsb_r   <= (s_axi_lite_awaddr[7:0] == DST_LSB_REG_ADDR)   ? s_axi_lite_wdata    : dst_lsb_r   ;
         len_r       <= (s_axi_lite_awaddr[7:0] == LEN_REG_ADDR)       ? s_axi_lite_wdata    : len_r       ;
         direction_r <= (s_axi_lite_awaddr[7:0] == DIRECTION_REG_ADDR) ? s_axi_lite_wdata[0] : direction_r ;
      end
   end

   // control axi cdma
   localparam IDLE           = 4'd0;
   localparam ADDR_TRANSLATE = 4'd1;
   localparam DECIDE_PRE     = 4'd2;
   localparam DECIDE         = 4'd3;
   localparam AXI_AR         = 4'd4;
   localparam AXI_R          = 4'd5;
   localparam AXI_W          = 4'd6;
   localparam AXI_B          = 4'd7;
   localparam WAIT_ACK       = 4'd8;

   localparam CDMACR_REG     = 16'h0;
   localparam CDMASR_REG     = 16'h4;
   localparam SA_REG         = 16'h18;
   localparam SA_MSB_REG     = 16'h1C;
   localparam DA_REG         = 16'h20;
   localparam DA_MSB_REG     = 16'h24;
   localparam BTT_REG        = 16'h28;

   reg [3:0]  state;
   reg [3:0]  decide_state;

   reg [1:0]  rd_cnt_r;
   reg [15:0] rd_addr_r;
   reg [31:0] rd_data_r;
   reg [2:0]  wr_cnt_r;
   reg [15:0] wr_addr_r;
   reg [31:0] wr_data_r;
   reg        ack_receved_r;

   always @(posedge clk) begin
      if(s_axi_lite_awvalid && s_axi_lite_awready) begin
         src_msb_r   <= (s_axi_lite_awaddr[7:0] == SRC_MSB_REG_ADDR)   ? s_axi_lite_wdata    : src_msb_r   ;
         dst_msb_r   <= (s_axi_lite_awaddr[7:0] == DST_MSB_REG_ADDR)   ? s_axi_lite_wdata    : dst_msb_r   ;
      end
      else if (state == ADDR_TRANSLATE) begin
         if (~direction_r) begin // c2h dma, source address(card memory) need to be changed.
            src_msb_r <= src_msb_r | (1 << (CARD_ADDRESS_BASE-32));
         end
         else begin // h2c dma, dstination address(card memory) need to be changed.
            dst_msb_r <= dst_msb_r | (1 << (CARD_ADDRESS_BASE-32));
         end
      end
   end


   always @ (posedge clk) begin
      if (state == IDLE) begin
         rd_cnt_r <= 'd0;
      end
      // if CDMASR.Idle is not rdy
      else if ((state == AXI_R) && m_axi_lite_rvalid && (rd_cnt_r == 'd0) && ~m_axi_lite_rdata[1]) begin
         rd_cnt_r <= 'd0;
      end
      else if ((state == AXI_R) && m_axi_lite_rvalid) begin
         rd_cnt_r <= rd_cnt_r + 'd1;
      end
   end

   always @ (posedge clk) begin
      if (state == DECIDE) begin
         case (rd_cnt_r)
            2'd0: rd_addr_r <= CDMASR_REG;
            2'd1: rd_addr_r <= CDMACR_REG;
            2'd2: rd_addr_r <= CDMASR_REG;
            default: rd_addr_r <= 'd0;
         endcase
      end
   end

   always @ (posedge clk) begin
      if (state == AXI_R) begin
         rd_data_r <= m_axi_lite_rdata;
      end
   end

   always @ (posedge clk) begin
      if (state == IDLE) begin
         wr_cnt_r <= 'd0;
      end
      else if ((state == AXI_W) && m_axi_lite_wready) begin
         wr_cnt_r <= wr_cnt_r + 'd1;
      end
   end

   always @ (posedge clk) begin
      if (state == DECIDE) begin
         case (wr_cnt_r)
            3'd0: begin
               wr_addr_r <= CDMACR_REG;
               wr_data_r <= rd_data_r | (1'b1 << 12);
            end
            3'd1: begin
               wr_addr_r <= SA_REG;
               wr_data_r <= src_lsb_r;
            end
            3'd2: begin
               wr_addr_r <= SA_MSB_REG;
               wr_data_r <= src_msb_r;
            end
            3'd3: begin
               wr_addr_r <= DA_REG;
               wr_data_r <= dst_lsb_r;
            end
            3'd4: begin
               wr_addr_r <= DA_MSB_REG;
               wr_data_r <= dst_msb_r;
            end
            3'd5: begin
               wr_addr_r <= BTT_REG;
               wr_data_r <= len_r;
            end
            3'd6: begin
               wr_addr_r <= CDMASR_REG;
               wr_data_r <= rd_data_r | (1'b1 << 12);
            end
            default: begin
               wr_addr_r <= 'd0;
               wr_data_r <= 'd0;
            end
         endcase
      end
   end

   always @ (posedge clk) begin
      if (state == DECIDE_PRE) begin
         if ((rd_cnt_r == 'd0) && (wr_cnt_r == 'd0)) begin
            decide_state <= AXI_AR;
         end
         else if ((rd_cnt_r == 'd1) && (wr_cnt_r == 'd0)) begin
            decide_state <= AXI_AR;
         end
         else if ((rd_cnt_r == 'd2) && (wr_cnt_r == 'd6) && ~ack_receved_r) begin
            decide_state <= WAIT_ACK;
         end
         else if ((rd_cnt_r == 'd2) && (wr_cnt_r == 'd6) && ack_receved_r) begin
            decide_state <= AXI_AR;
         end
         else if ((rd_cnt_r == 'd3) && (wr_cnt_r == 'd7)) begin
            decide_state <= IDLE;
         end
         else begin
            decide_state <= AXI_W;
         end
      end
   end

   always @ (posedge clk) begin
      if (state == IDLE) begin
         ack_receved_r <= 1'b0;
      end
      else if (usr_irq_ack[0] && (state == WAIT_ACK)) begin
         ack_receved_r <= 1'b1;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         state <= IDLE;
      end
      else begin
         case (state)
            IDLE:begin
               if ((s_axi_lite_awaddr[7:0] == START_REG_ADDR) && s_axi_lite_awready && s_axi_lite_awvalid) begin
                  state <= ADDR_TRANSLATE;
               end
               else begin
                  state <= IDLE;
               end
            end
            ADDR_TRANSLATE:begin
               state <= DECIDE_PRE;
            end
            DECIDE_PRE:begin
               state <= DECIDE;
            end
            DECIDE:begin
               state <= decide_state;
            end
            AXI_AR:begin
               if (m_axi_lite_arready) begin
                  state <= AXI_R;
               end
               else begin
                  state <= AXI_AR;
               end
            end
            AXI_R:begin
               if (m_axi_lite_rvalid) begin
                  state <= DECIDE_PRE;
               end
               else begin
                  state <= AXI_R;
               end
            end
            AXI_W:begin
               if (m_axi_lite_wready) begin
                  state <= AXI_B;
               end
               else begin
                  state <= AXI_W;
               end
            end
            AXI_B:begin
               if (m_axi_lite_bvalid) begin
                  state <= DECIDE_PRE;
               end
               else begin
                  state <= AXI_B;
               end
            end
            WAIT_ACK:begin
               if (usr_irq_ack[0]) begin
                  state <= DECIDE_PRE;
               end
               else begin
                  state <= WAIT_ACK;
               end
            end
         endcase
      end
   end

   assign m_axi_lite_araddr  = rd_addr_r;
   assign m_axi_lite_arprot  = 3'b0;
   assign m_axi_lite_arvalid = (state == AXI_AR);
   assign m_axi_lite_awaddr  = wr_addr_r;
   assign m_axi_lite_awprot  = 3'b0;
   assign m_axi_lite_awvalid = (state == AXI_W);
   assign m_axi_lite_bready  = (state == AXI_B);
   assign m_axi_lite_rready  = (state == AXI_R);
   assign m_axi_lite_wdata   = wr_data_r;
   assign m_axi_lite_wstrb   = 4'hf;
   assign m_axi_lite_wvalid  = (state == AXI_W);

   assign dbg_bus = {rd_cnt_r,wr_cnt_r,state};
   assign usr_irq_req = {{(15){1'b0}},axi_cdma_interrupt};

endmodule
