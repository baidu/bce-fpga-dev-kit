//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: axi_req_mux1.v
//    Data last Modified:
//    Data Created:June 2nd, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: axi requeset mux, 5-slave 1-master
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps
module axi_req_mux1 #(
   parameter IN_NUM     = 5,
   parameter ID_WIDTH   = 4,
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8
)(
   input                    clk,
   input                    rst,

   //slave axi input
   input  [IN_NUM*ADDR_WIDTH-1:0]  s_araddr,
   input  [IN_NUM*8-1:0]           s_arlen,
   output [IN_NUM-1:0]             s_arready,
   input  [IN_NUM-1:0]             s_arvalid,
   input  [IN_NUM*ADDR_WIDTH-1:0]  s_awaddr,
   input  [IN_NUM*8-1:0]           s_awlen,
   output [IN_NUM-1:0]             s_awready,
   input  [IN_NUM-1:0]             s_awvalid,
   input  [IN_NUM-1:0]             s_bready,
   output [IN_NUM-1:0]             s_bvalid,
   output [IN_NUM*DATA_WIDTH-1:0]  s_rdata,
   input  [IN_NUM-1:0]             s_rready,
   output [IN_NUM-1:0]             s_rvalid,
   output [IN_NUM-1:0]             s_rlast,
   input  [IN_NUM*DATA_WIDTH-1:0]  s_wdata,
   output [IN_NUM-1:0]             s_wready,
   input  [IN_NUM-1:0]             s_wlast,
   input  [IN_NUM*MASK_WIDTH-1:0]  s_wstrb,
   input  [IN_NUM-1:0]             s_wvalid,

   // AXI Master AW channel
   output [ADDR_WIDTH-1:0]  araddr,
   output [1:0]             arburst,
   output [3:0]             arcache,
   output [ID_WIDTH-1:0]    arid,
   output [7:0]             arlen,
   output                   arlock,
   output [2:0]             arprot,
   output [3:0]             arqos,
   output [3:0]             arregion,
   input                    arready,
   output [2:0]             arsize,
   output                   arvalid,
   // AXI Master AR channel
   output [ADDR_WIDTH-1:0]  awaddr,
   output [1:0]             awburst,
   output [3:0]             awcache,
   output [ID_WIDTH-1:0]    awid,
   output [7:0]             awlen,
   output                   awlock,
   output [2:0]             awprot,
   output [3:0]             awqos,
   output [3:0]             awregion,
   input                    awready,
   output [2:0]             awsize,
   output                   awvalid,
   // AXI Master B channel
   input  [ID_WIDTH-1:0]    bid,
   output                   bready,
   input  [1:0]             bresp,
   input                    bvalid,
   // AXI Master R channel
   input  [DATA_WIDTH-1:0]  rdata,
   input  [ID_WIDTH-1:0]    rid,
   input                    rlast,
   output                   rready,
   input  [1:0]             rresp,
   input                    rvalid,
   // AXI Master W channel
   output [DATA_WIDTH-1:0]  wdata,
   output                   wlast,
   input                    wready,
   output [MASK_WIDTH-1:0]  wstrb,
   output                   wvalid
);

   localparam ADDR_ALIGN_BITS = $clog2(MASK_WIDTH);
   wire   [IN_NUM*ID_WIDTH-1:0]    s_arid;
   wire   [IN_NUM*ID_WIDTH-1:0]    s_awid;

   genvar i;
   generate
   for (i=0; i<IN_NUM; i=i+1) begin:gen_id
      assign s_arid[i*ID_WIDTH+ID_WIDTH-1:i*ID_WIDTH] = i;
      assign s_awid[i*ID_WIDTH+ID_WIDTH-1:i*ID_WIDTH] = i;
   end
   endgenerate

   /**************** Write Address Channel Signals ****************/
   wire [IN_NUM*ADDR_WIDTH-1:0]  s_axi_awaddr;
   wire [IN_NUM*3-1:0]           s_axi_awprot;
   wire [IN_NUM*1-1:0]           s_axi_awvalid;
   wire [IN_NUM*1-1:0]           s_axi_awready;
   wire [IN_NUM*3-1:0]           s_axi_awsize;
   wire [IN_NUM*2-1:0]           s_axi_awburst;
   wire [IN_NUM*4-1:0]           s_axi_awcache;
   wire [IN_NUM*4-1:0]           s_axi_awqos;
   wire [IN_NUM*8-1:0]           s_axi_awlen;
   wire [IN_NUM*1-1:0]           s_axi_awlock;
   wire [IN_NUM*ID_WIDTH-1:0]    s_axi_awid;
   /**************** Write Data Channel Signals ****************/
   wire [IN_NUM*DATA_WIDTH-1:0]  s_axi_wdata;
   wire [IN_NUM*MASK_WIDTH-1:0]  s_axi_wstrb;
   wire [IN_NUM*1-1:0]           s_axi_wvalid;
   wire [IN_NUM*1-1:0]           s_axi_wready;
   wire [IN_NUM*1-1:0]           s_axi_wlast;
   /**************** Write Response Channel Signals ****************/
   wire [IN_NUM*2-1:0]           s_axi_bresp;
   wire [IN_NUM*1-1:0]           s_axi_bvalid;
   wire [IN_NUM*1-1:0]           s_axi_bready;
   wire [IN_NUM*ID_WIDTH-1:0]    s_axi_bid;
   /**************** Read Address Channel Signals ****************/
   wire [IN_NUM*ADDR_WIDTH-1:0]  s_axi_araddr;
   wire [IN_NUM*3-1:0]           s_axi_arprot;
   wire [IN_NUM*1-1:0]           s_axi_arvalid;
   wire [IN_NUM*1-1:0]           s_axi_arready;
   wire [IN_NUM*3-1:0]           s_axi_arsize;
   wire [IN_NUM*2-1:0]           s_axi_arburst;
   wire [IN_NUM*4-1:0]           s_axi_arcache;
   wire [IN_NUM*4-1:0]           s_axi_arqos;
   wire [IN_NUM*8-1:0]           s_axi_arlen;
   wire [IN_NUM*1-1:0]           s_axi_arlock;
   wire [IN_NUM*ID_WIDTH-1:0]    s_axi_arid;
   /**************** Read Data Channel Signals ****************/
   wire [IN_NUM*DATA_WIDTH-1:0]  s_axi_rdata;
   wire [IN_NUM*2-1:0]           s_axi_rresp;
   wire [IN_NUM*1-1:0]           s_axi_rvalid;
   wire [IN_NUM*1-1:0]           s_axi_rready;
   wire [IN_NUM*1-1:0]           s_axi_rlast;
   wire [IN_NUM*ID_WIDTH-1:0]    s_axi_rid;

   wire [2:0]               axi_size;

   assign axi_size       = ADDR_ALIGN_BITS;

   assign s_axi_arprot   = {(IN_NUM*1){3'd0}};
   assign s_axi_arsize   = {(IN_NUM*1){axi_size}};
   assign s_axi_arburst  = {(IN_NUM*1){2'b1}};
   assign s_axi_arcache  = {(IN_NUM*1){4'd3}};
   assign s_axi_arqos    = {(IN_NUM*1){4'd0}};
   assign s_axi_arlock   = {(IN_NUM*1){1'b0}};
   assign s_axi_arid     = s_arid;
   assign s_axi_araddr   = s_araddr;
   assign s_axi_arlen    = s_arlen;
   assign s_axi_arvalid  = s_arvalid;
   assign s_arready      = s_axi_arready;

   assign s_axi_awprot   = {(IN_NUM*1){3'd0}};
   assign s_axi_awsize   = {(IN_NUM*1){axi_size}};
   assign s_axi_awburst  = {(IN_NUM*1){2'b1}};
   assign s_axi_awcache  = {(IN_NUM*1){4'd3}};
   assign s_axi_awqos    = {(IN_NUM*1){4'd0}};
   assign s_axi_awlock   = {(IN_NUM*1){1'b0}};
   assign s_axi_awid     = s_awid;
   assign s_axi_awaddr   = s_awaddr;
   assign s_axi_awlen    = s_awlen;
   assign s_axi_awvalid  = s_awvalid;
   assign s_awready      = s_axi_awready;

   assign s_axi_bready   = s_bready;
   assign s_bvalid       = s_axi_bvalid;

   assign s_axi_rready   = s_rready;
   assign s_rvalid       = s_axi_rvalid;
   assign s_rlast        = s_axi_rlast;
   assign s_rdata        = s_axi_rdata;

   assign s_axi_wdata    = s_wdata;
   assign s_axi_wstrb    = s_wstrb;
   assign s_axi_wvalid   = s_wvalid;
   assign s_axi_wlast    = s_wlast;
   assign s_wready       = s_axi_wready;

   axi_crossbar_5s_1m axi_crossbar_5s_1m
   (
      /**************** Write Address Channel Signals ****************/
      .s_axi_awaddr(s_axi_awaddr),
      .s_axi_awprot(s_axi_awprot),
      .s_axi_awvalid(s_axi_awvalid),
      .s_axi_awready(s_axi_awready),
      .s_axi_awsize(s_axi_awsize),
      .s_axi_awburst(s_axi_awburst),
      .s_axi_awcache(s_axi_awcache),
      .s_axi_awlen(s_axi_awlen),
      .s_axi_awlock(s_axi_awlock),
      .s_axi_awqos(s_axi_awqos),
      .s_axi_awid(s_axi_awid),
      /**************** Write Data Channel Signals ****************/
      .s_axi_wdata(s_axi_wdata),
      .s_axi_wstrb(s_axi_wstrb),
      .s_axi_wvalid(s_axi_wvalid),
      .s_axi_wready(s_axi_wready),
      .s_axi_wlast(s_axi_wlast),
      /**************** Write Response Channel Signals ****************/
      .s_axi_bresp(s_axi_bresp),
      .s_axi_bvalid(s_axi_bvalid),
      .s_axi_bready(s_axi_bready),
      .s_axi_bid(s_axi_bid),
      /**************** Read Address Channel Signals ****************/
      .s_axi_araddr(s_axi_araddr),
      .s_axi_arprot(s_axi_arprot),
      .s_axi_arvalid(s_axi_arvalid),
      .s_axi_arready(s_axi_arready),
      .s_axi_arsize(s_axi_arsize),
      .s_axi_arburst(s_axi_arburst),
      .s_axi_arcache(s_axi_arcache),
      .s_axi_arlock(s_axi_arlock),
      .s_axi_arlen(s_axi_arlen),
      .s_axi_arqos(s_axi_arqos),
      .s_axi_arid(s_axi_arid),
      /**************** Read Data Channel Signals ****************/
      .s_axi_rdata(s_axi_rdata),
      .s_axi_rresp(s_axi_rresp),
      .s_axi_rvalid(s_axi_rvalid),
      .s_axi_rready(s_axi_rready),
      .s_axi_rlast(s_axi_rlast),
      .s_axi_rid(s_axi_rid),

      /**************** Write Address Channel Signals ****************/
      .m_axi_awaddr(awaddr),
      .m_axi_awprot(awprot),
      .m_axi_awvalid(awvalid),
      .m_axi_awready(awready),
      .m_axi_awsize(awsize),
      .m_axi_awburst(awburst),
      .m_axi_awcache(awcache),
      .m_axi_awlen(awlen),
      .m_axi_awlock(awlock),
      .m_axi_awqos(awqos),
      .m_axi_awid(awid),
      .m_axi_awregion(awregion),
      /**************** Write Data Channel Signals ****************/
      .m_axi_wdata(wdata),
      .m_axi_wstrb(wstrb),
      .m_axi_wvalid(wvalid),
      .m_axi_wready(wready),
      .m_axi_wlast(wlast),
      /**************** Write Response Channel Signals ****************/
      .m_axi_bresp(bresp),
      .m_axi_bvalid(bvalid),
      .m_axi_bready(bready),
      .m_axi_bid(bid),
      /**************** Read Address Channel Signals ****************/
      .m_axi_araddr(araddr),
      .m_axi_arprot(arprot),
      .m_axi_arvalid(arvalid),
      .m_axi_arready(arready),
      .m_axi_arsize(arsize),
      .m_axi_arburst(arburst),
      .m_axi_arcache(arcache),
      .m_axi_arlock(arlock),
      .m_axi_arlen(arlen),
      .m_axi_arqos(arqos),
      .m_axi_arid(arid),
      .m_axi_arregion(arregion),
      /**************** Read Data Channel Signals ****************/
      .m_axi_rdata(rdata),
      .m_axi_rresp(rresp),
      .m_axi_rvalid(rvalid),
      .m_axi_rready(rready),
      .m_axi_rlast(rlast),
      .m_axi_rid(rid),

      /**************** System Signals ****************/
      .aclk(clk),
      .aresetn(~rst)
  );

endmodule
