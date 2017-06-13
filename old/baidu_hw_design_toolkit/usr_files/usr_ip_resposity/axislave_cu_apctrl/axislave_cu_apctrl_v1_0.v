
`timescale 1 ns / 1 ps

	module axislave_cu_apctrl_v1_0 #
	(
		// Users to add parameters here
		parameter integer INTERRPT_WIDTH = 16,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 16
	)
	(
		// Users to add ports here
		output	[INTERRPT_WIDTH-1:0]	o_interrpt_rdy,
	        input	[INTERRPT_WIDTH-1:0]	i_interrpt_done,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

        output     ap_start,
        input      ap_done,
        input      ap_idle,
        input      ap_ready,

        output     [31:0] A_array_baseaddr,
        output     [31:0] B_array_baseaddr,
        output     [31:0] C_array_baseaddr,
        output     [15:0] array_len,
        output     A_array_baseaddr_vld,
        output     B_array_baseaddr_vld,
        output     C_array_baseaddr_vld,
        output     arrayu_len_vld,
        output     soft_rst_n
	);

// axi addr has 6 bit, which means there are 16 registers (each is 32bit-width)
// reg 0   : Write-Only, start command
// reg 1   : Read-Write, A array addr
// reg 2   : Read-Write, B array addr
// reg 3   : Read-Write, C array addr
// reg 4   : Read-Write, array len
// reg 5~7 : Read-Write, test register
// reg 8   : Read-Only, version register
// reg 9   : Read-Only, polling register
// reg 10  : Write-Only, soft reset

	reg polling_r;
    wire [31:0] slv_reg0;
    wire [31:0] slv_reg1;
    wire [31:0] slv_reg2;
    wire [31:0] slv_reg3;
    wire [31:0] slv_reg4;
    wire [31:0] slv_reg5;
    wire [31:0] slv_reg6;
    wire [31:0] slv_reg7;

// Instantiation of Axi Bus Interface S00_AXI
	axislave_cu_apctrl_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axislave_cu_apctrl_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),

        .slv_reg0(slv_reg0),
        .slv_reg1(slv_reg1),
        .slv_reg2(slv_reg2),
        .slv_reg3(slv_reg3),
        .slv_reg4(slv_reg4),
        .slv_reg5(slv_reg5),
        .slv_reg6(slv_reg6),
        .slv_reg7(slv_reg7),
        .polling(polling_r)
	);

	// Add user logic here
    localparam START_CMD_ADDR = 14'h0;
    localparam SOFT_RST_CMD_ADDR = 14'hA;
    localparam INT_CLEAR_CMD_ADDR = 14'h3F00; // byte addr = 63K
	localparam integer ADDR_LSB = (C_S00_AXI_DATA_WIDTH/32) + 1;
    // localparam integer OPT_MEM_ADDR_BITS = 3;
    
        reg ap_start_r;
        reg ap_working_r;
        reg soft_rst_r,soft_rst_r1,soft_rst_r2;

        assign A_array_baseaddr   = slv_reg1[31:5] ;
        assign B_array_baseaddr   = slv_reg2[31:5];
        assign C_array_baseaddr   = slv_reg3[31:5];
        assign array_len          = slv_reg4[18:3];
        assign ap_start           = ap_working_r;
        assign A_array_baseaddr_vld = ap_working_r;
        assign B_array_baseaddr_vld = ap_working_r;
        assign C_array_baseaddr_vld = ap_working_r;
        assign arrayu_len_vld       = ap_working_r;
        assign soft_rst_n           = ~(soft_rst_r | soft_rst_r1 | soft_rst_r2);

        always @(posedge s00_axi_aclk) begin
           if (~s00_axi_aresetn) begin
              ap_working_r <= 1'b0;
           end
           else if (~ap_working_r && ap_start_r) begin
              ap_working_r <= 1'b1;
           end
           else if (ap_working_r && ap_done) begin
              ap_working_r <= 1'b0;
           end
        end

        always @(posedge s00_axi_aclk) begin
           ap_start_r <= (~ap_working_r && s00_axi_awvalid && s00_axi_awready && (s00_axi_awaddr[C_S00_AXI_ADDR_WIDTH-1:ADDR_LSB] == START_CMD_ADDR));
        end
        
        always @(posedge s00_axi_aclk) begin
           soft_rst_r <= (s00_axi_awvalid && s00_axi_awready && (s00_axi_awaddr[C_S00_AXI_ADDR_WIDTH-1:ADDR_LSB] == SOFT_RST_CMD_ADDR));
           soft_rst_r1 <= soft_rst_r;
           soft_rst_r2 <= soft_rst_r1;
        end        
        
        always @(posedge s00_axi_aclk) begin
           if (~s00_axi_aresetn) begin
              polling_r <= 1'b0;
           end
           /*else if (~ap_working_r && ap_start_r) begin
              polling_r <= 1'b0;
           end
           else if (ap_done) begin
              polling_r <= 1'b1;
           end*/
        end        

	reg [15:0] finish_cnt = 0; //256 us to cycle this counter
	always@(posedge s00_axi_aclk) begin
            if (~s00_axi_aresetn) begin
		finish_cnt <= 'd0;
            end
	    else if (finish_cnt != 'd0) begin
		finish_cnt <= finish_cnt + 'd1;
            end
            else if (ap_working_r && ap_done) begin
		finish_cnt <= 'd1;
	    end
	end

	// interrupt management
	// 1. when vector add PE finish: interrupt on usr_irq_req[0]
	// 2. other usr_irq_req[15:1] not used
	// 3. when reg write on INT_CLEAR_CMD_ADDR, clear usr_irq_req bit
	reg [INTERRPT_WIDTH-1:0] usr_interrpt_clr = 0;
        always @(posedge s00_axi_aclk) begin
           if (s00_axi_awvalid && s00_axi_awready && (s00_axi_awaddr[C_S00_AXI_ADDR_WIDTH-1:ADDR_LSB] == INT_CLEAR_CMD_ADDR))
		usr_interrpt_clr <= s00_axi_wdata[15:0];
	   else 
		usr_interrpt_clr <= 'd0;
	end

	reg vector_add_interrpt = 0;
	always@(posedge s00_axi_aclk) begin
            if (~s00_axi_aresetn) begin
		vector_add_interrpt <= 'd0;
            end
            //else if (ap_working_r && ap_done) begin
            else if (finish_cnt == 16'hffff) begin
                vector_add_interrpt <= 'd1;
            end
	    // keep usr_irq_req even if ack is asserted
	    // clear irg_req on usr_interrpt_clr[0]
	    else if (usr_interrpt_clr[0]) begin
		vector_add_interrpt <= 'd0;
	    end
	end
	assign	o_interrpt_rdy[0] = vector_add_interrpt;
        // other usr_irq_req[15:1] is not used
        generate
	if (INTERRPT_WIDTH > 1) begin : interrpt
 	    assign o_interrpt_rdy[INTERRPT_WIDTH-1 : 1] = 0;
	end
        endgenerate


	// User logic ends

	endmodule
