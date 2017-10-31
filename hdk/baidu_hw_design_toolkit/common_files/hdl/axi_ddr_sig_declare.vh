  `ifdef USE_DDR4_C0
  wire [31:0]C0_DDR4_S_AXI_CTRL_araddr;
  wire C0_DDR4_S_AXI_CTRL_arready;
  wire C0_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_awaddr;
  wire C0_DDR4_S_AXI_CTRL_awready;
  wire C0_DDR4_S_AXI_CTRL_awvalid;
  wire C0_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C0_DDR4_S_AXI_CTRL_bresp;
  wire C0_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_rdata;
  wire C0_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C0_DDR4_S_AXI_CTRL_rresp;
  wire C0_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_wdata;
  wire C0_DDR4_S_AXI_CTRL_wready;
  wire C0_DDR4_S_AXI_CTRL_wvalid;

  wire [30:0]C0_DDR4_S_AXI_araddr;
  wire [1:0]C0_DDR4_S_AXI_arburst;
  wire [3:0]C0_DDR4_S_AXI_arcache;
  wire [7:0]C0_DDR4_S_AXI_arlen;
  wire [0:0]C0_DDR4_S_AXI_arlock;
  wire [2:0]C0_DDR4_S_AXI_arprot;
  wire [3:0]C0_DDR4_S_AXI_arqos;
  wire C0_DDR4_S_AXI_arready;
  wire [2:0]C0_DDR4_S_AXI_arsize;
  wire C0_DDR4_S_AXI_arvalid;
  wire [30:0]C0_DDR4_S_AXI_awaddr;
  wire [1:0]C0_DDR4_S_AXI_awburst;
  wire [3:0]C0_DDR4_S_AXI_awcache;
  wire [7:0]C0_DDR4_S_AXI_awlen;
  wire [0:0]C0_DDR4_S_AXI_awlock;
  wire [2:0]C0_DDR4_S_AXI_awprot;
  wire [3:0]C0_DDR4_S_AXI_awqos;
  wire C0_DDR4_S_AXI_awready;
  wire [2:0]C0_DDR4_S_AXI_awsize;
  wire C0_DDR4_S_AXI_awvalid;
  wire C0_DDR4_S_AXI_bready;
  wire [1:0]C0_DDR4_S_AXI_bresp;
  wire C0_DDR4_S_AXI_bvalid;
  wire [511:0]C0_DDR4_S_AXI_rdata;
  wire C0_DDR4_S_AXI_rlast;
  wire C0_DDR4_S_AXI_rready;
  wire [1:0]C0_DDR4_S_AXI_rresp;
  wire C0_DDR4_S_AXI_rvalid;
  wire [511:0]C0_DDR4_S_AXI_wdata;
  wire C0_DDR4_S_AXI_wlast;
  wire C0_DDR4_S_AXI_wready;
  wire [63:0]C0_DDR4_S_AXI_wstrb;
  wire C0_DDR4_S_AXI_wvalid;
  `ifdef C0_DDR4_AXIID
  wire [`C0_DDR4_AXIID_WIDTH-1:0]    C0_DDR4_S_AXI_arid;
  wire [`C0_DDR4_AXIID_WIDTH-1:0]    C0_DDR4_S_AXI_awid;
  wire [`C0_DDR4_AXIID_WIDTH-1:0]    C0_DDR4_S_AXI_bid;
  wire [`C0_DDR4_AXIID_WIDTH-1:0]    C0_DDR4_S_AXI_rid;
  `endif
  `endif

  `ifdef USE_DDR4_C1
  wire [31:0]C1_DDR4_S_AXI_CTRL_araddr;
  wire C1_DDR4_S_AXI_CTRL_arready;
  wire C1_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_awaddr;
  wire C1_DDR4_S_AXI_CTRL_awready;
  wire C1_DDR4_S_AXI_CTRL_awvalid;
  wire C1_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C1_DDR4_S_AXI_CTRL_bresp;
  wire C1_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_rdata;
  wire C1_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C1_DDR4_S_AXI_CTRL_rresp;
  wire C1_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_wdata;
  wire C1_DDR4_S_AXI_CTRL_wready;
  wire C1_DDR4_S_AXI_CTRL_wvalid;

  wire [30:0]C1_DDR4_S_AXI_araddr;
  wire [1:0]C1_DDR4_S_AXI_arburst;
  wire [3:0]C1_DDR4_S_AXI_arcache;
  wire [7:0]C1_DDR4_S_AXI_arlen;
  wire [0:0]C1_DDR4_S_AXI_arlock;
  wire [2:0]C1_DDR4_S_AXI_arprot;
  wire [3:0]C1_DDR4_S_AXI_arqos;
  wire C1_DDR4_S_AXI_arready;
  wire [2:0]C1_DDR4_S_AXI_arsize;
  wire C1_DDR4_S_AXI_arvalid;
  wire [30:0]C1_DDR4_S_AXI_awaddr;
  wire [1:0]C1_DDR4_S_AXI_awburst;
  wire [3:0]C1_DDR4_S_AXI_awcache;
  wire [7:0]C1_DDR4_S_AXI_awlen;
  wire [0:0]C1_DDR4_S_AXI_awlock;
  wire [2:0]C1_DDR4_S_AXI_awprot;
  wire [3:0]C1_DDR4_S_AXI_awqos;
  wire C1_DDR4_S_AXI_awready;
  wire [2:0]C1_DDR4_S_AXI_awsize;
  wire C1_DDR4_S_AXI_awvalid;
  wire C1_DDR4_S_AXI_bready;
  wire [1:0]C1_DDR4_S_AXI_bresp;
  wire C1_DDR4_S_AXI_bvalid;
  wire [511:0]C1_DDR4_S_AXI_rdata;
  wire C1_DDR4_S_AXI_rlast;
  wire C1_DDR4_S_AXI_rready;
  wire [1:0]C1_DDR4_S_AXI_rresp;
  wire C1_DDR4_S_AXI_rvalid;
  wire [511:0]C1_DDR4_S_AXI_wdata;
  wire C1_DDR4_S_AXI_wlast;
  wire C1_DDR4_S_AXI_wready;
  wire [63:0]C1_DDR4_S_AXI_wstrb;
  wire C1_DDR4_S_AXI_wvalid;
  `ifdef C1_DDR4_AXIID
  wire [`C1_DDR4_AXIID_WIDTH-1:0]    C1_DDR4_S_AXI_arid;
  wire [`C1_DDR4_AXIID_WIDTH-1:0]    C1_DDR4_S_AXI_awid;
  wire [`C1_DDR4_AXIID_WIDTH-1:0]    C1_DDR4_S_AXI_bid;
  wire [`C1_DDR4_AXIID_WIDTH-1:0]    C1_DDR4_S_AXI_rid;
  `endif
  `endif

  `ifdef USE_DDR4_C2
  wire [31:0]C2_DDR4_S_AXI_CTRL_araddr;
  wire C2_DDR4_S_AXI_CTRL_arready;
  wire C2_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_awaddr;
  wire C2_DDR4_S_AXI_CTRL_awready;
  wire C2_DDR4_S_AXI_CTRL_awvalid;
  wire C2_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C2_DDR4_S_AXI_CTRL_bresp;
  wire C2_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_rdata;
  wire C2_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C2_DDR4_S_AXI_CTRL_rresp;
  wire C2_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_wdata;
  wire C2_DDR4_S_AXI_CTRL_wready;
  wire C2_DDR4_S_AXI_CTRL_wvalid;

  wire [30:0]C2_DDR4_S_AXI_araddr;
  wire [1:0]C2_DDR4_S_AXI_arburst;
  wire [3:0]C2_DDR4_S_AXI_arcache;
  wire [7:0]C2_DDR4_S_AXI_arlen;
  wire [0:0]C2_DDR4_S_AXI_arlock;
  wire [2:0]C2_DDR4_S_AXI_arprot;
  wire [3:0]C2_DDR4_S_AXI_arqos;
  wire C2_DDR4_S_AXI_arready;
  wire [2:0]C2_DDR4_S_AXI_arsize;
  wire C2_DDR4_S_AXI_arvalid;
  wire [30:0]C2_DDR4_S_AXI_awaddr;
  wire [1:0]C2_DDR4_S_AXI_awburst;
  wire [3:0]C2_DDR4_S_AXI_awcache;
  wire [7:0]C2_DDR4_S_AXI_awlen;
  wire [0:0]C2_DDR4_S_AXI_awlock;
  wire [2:0]C2_DDR4_S_AXI_awprot;
  wire [3:0]C2_DDR4_S_AXI_awqos;
  wire C2_DDR4_S_AXI_awready;
  wire [2:0]C2_DDR4_S_AXI_awsize;
  wire C2_DDR4_S_AXI_awvalid;
  wire C2_DDR4_S_AXI_bready;
  wire [1:0]C2_DDR4_S_AXI_bresp;
  wire C2_DDR4_S_AXI_bvalid;
  wire [511:0]C2_DDR4_S_AXI_rdata;
  wire C2_DDR4_S_AXI_rlast;
  wire C2_DDR4_S_AXI_rready;
  wire [1:0]C2_DDR4_S_AXI_rresp;
  wire C2_DDR4_S_AXI_rvalid;
  wire [511:0]C2_DDR4_S_AXI_wdata;
  wire C2_DDR4_S_AXI_wlast;
  wire C2_DDR4_S_AXI_wready;
  wire [63:0]C2_DDR4_S_AXI_wstrb;
  wire C2_DDR4_S_AXI_wvalid;
  `ifdef C2_DDR4_AXIID
  wire [`C2_DDR4_AXIID_WIDTH-1:0]    C2_DDR4_S_AXI_arid;
  wire [`C2_DDR4_AXIID_WIDTH-1:0]    C2_DDR4_S_AXI_awid;
  wire [`C2_DDR4_AXIID_WIDTH-1:0]    C2_DDR4_S_AXI_bid;
  wire [`C2_DDR4_AXIID_WIDTH-1:0]    C2_DDR4_S_AXI_rid;
  `endif
  `endif

  `ifdef USE_DDR4_C3
  wire [31:0]C3_DDR4_S_AXI_CTRL_araddr;
  wire C3_DDR4_S_AXI_CTRL_arready;
  wire C3_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_awaddr;
  wire C3_DDR4_S_AXI_CTRL_awready;
  wire C3_DDR4_S_AXI_CTRL_awvalid;
  wire C3_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C3_DDR4_S_AXI_CTRL_bresp;
  wire C3_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_rdata;
  wire C3_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C3_DDR4_S_AXI_CTRL_rresp;
  wire C3_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_wdata;
  wire C3_DDR4_S_AXI_CTRL_wready;
  wire C3_DDR4_S_AXI_CTRL_wvalid;

  wire [30:0]C3_DDR4_S_AXI_araddr;
  wire [1:0]C3_DDR4_S_AXI_arburst;
  wire [3:0]C3_DDR4_S_AXI_arcache;
  wire [7:0]C3_DDR4_S_AXI_arlen;
  wire [0:0]C3_DDR4_S_AXI_arlock;
  wire [2:0]C3_DDR4_S_AXI_arprot;
  wire [3:0]C3_DDR4_S_AXI_arqos;
  wire C3_DDR4_S_AXI_arready;
  wire [2:0]C3_DDR4_S_AXI_arsize;
  wire C3_DDR4_S_AXI_arvalid;
  wire [30:0]C3_DDR4_S_AXI_awaddr;
  wire [1:0]C3_DDR4_S_AXI_awburst;
  wire [3:0]C3_DDR4_S_AXI_awcache;
  wire [7:0]C3_DDR4_S_AXI_awlen;
  wire [0:0]C3_DDR4_S_AXI_awlock;
  wire [2:0]C3_DDR4_S_AXI_awprot;
  wire [3:0]C3_DDR4_S_AXI_awqos;
  wire C3_DDR4_S_AXI_awready;
  wire [2:0]C3_DDR4_S_AXI_awsize;
  wire C3_DDR4_S_AXI_awvalid;
  wire C3_DDR4_S_AXI_bready;
  wire [1:0]C3_DDR4_S_AXI_bresp;
  wire C3_DDR4_S_AXI_bvalid;
  wire [511:0]C3_DDR4_S_AXI_rdata;
  wire C3_DDR4_S_AXI_rlast;
  wire C3_DDR4_S_AXI_rready;
  wire [1:0]C3_DDR4_S_AXI_rresp;
  wire C3_DDR4_S_AXI_rvalid;
  wire [511:0]C3_DDR4_S_AXI_wdata;
  wire C3_DDR4_S_AXI_wlast;
  wire C3_DDR4_S_AXI_wready;
  wire [63:0]C3_DDR4_S_AXI_wstrb;
  wire C3_DDR4_S_AXI_wvalid;

  `ifdef C3_DDR4_AXIID
  wire [`C3_DDR4_AXIID_WIDTH-1:0]    C3_DDR4_S_AXI_arid;
  wire [`C3_DDR4_AXIID_WIDTH-1:0]    C3_DDR4_S_AXI_awid;
  wire [`C3_DDR4_AXIID_WIDTH-1:0]    C3_DDR4_S_AXI_bid;
  wire [`C3_DDR4_AXIID_WIDTH-1:0]    C3_DDR4_S_AXI_rid;
  `endif
  `endif

  wire c0_ddr4_interrupt;
  wire c1_ddr4_interrupt;
  wire c2_ddr4_interrupt;
  wire c3_ddr4_interrupt;
