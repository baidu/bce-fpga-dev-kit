百度云FPGA提供了8GB板载四通道DDR4-2400 ECC内存，为了方便用户在逻辑中使用DDR，我们在FPGA云服务器镜像的制作流程中实现了自动生成MIG控制器的功能，用户只需在build/script/step_00_setup.tcl中定义好想使用的DDR通道和接口类型，并在自己的RP_bd中实现对应的接口逻辑即可。

MIG控制器与用户逻辑的接口速率为300M，暂时不支持用户自定义MIG的工作频率。

## 配置文件

不使用DDR

	# Use DDR Channel Setting
	set USE_DDR4_C0 0
	set USE_DDR4_C1 0
	set USE_DDR4_C2 0
	set USE_DDR4_C3 0

使用DDR C2，mig控制器接口为AXI

	# Use DDR Channel Setting
	set USE_DDR4_C0 0
	set USE_DDR4_C1 0
	set USE_DDR4_C2 1
	set USE_DDR4_C3 0
	# Use AXI mig core
	set USE_AXI_DDR 1

使用DDR C1 C3，mig控制器接口为APP

	# Use DDR Channel Setting
	set USE_DDR4_C0 0
	set USE_DDR4_C1 1
	set USE_DDR4_C2 0
	set USE_DDR4_C3 1
	# Use AXI mig core
	set USE_AXI_DDR 0


## 接口定义

用户自己实现的RP_bd接口首先要与step_00_setup.tcl配置文件匹配，也就是说配置文件使用了C1通道APP接口的MIG，RP_bd就必须提供C1通道APP接口。
另外接口也需要遵守一定的命名规则，具体可参考~/hdk/baidu_hw_design_toolkit/common_files/hdl/里面的mig_wrapper_port_app.vh和mig_wrapper_port_axi.vh。注意RP_bd中的这些port和这两个文件中port的input/output是相反的。
以C0为例，使用AXI接口的MIG时，RP_bd应提供如下接口

    output[30:0]    C0_DDR4_M_AXI_araddr,
    output[1:0]     C0_DDR4_M_AXI_arburst,
    output[3:0]     C0_DDR4_M_AXI_arcache,
    output[0:0]     C0_DDR4_M_AXI_arid,
    output[7:0]     C0_DDR4_M_AXI_arlen,
    output[0:0]     C0_DDR4_M_AXI_arlock,
    output[2:0]     C0_DDR4_M_AXI_arprot,
    output[3:0]     C0_DDR4_M_AXI_arqos,
    input           C0_DDR4_M_AXI_arready,
    output[2:0]     C0_DDR4_M_AXI_arsize,
    output          C0_DDR4_M_AXI_arvalid,
    output[30:0]    C0_DDR4_M_AXI_awaddr,
    output[1:0]     C0_DDR4_M_AXI_awburst,
    output[3:0]     C0_DDR4_M_AXI_awcache,
    output[0:0]     C0_DDR4_M_AXI_awid,
    output[7:0]     C0_DDR4_M_AXI_awlen,
    output[0:0]     C0_DDR4_M_AXI_awlock,
    output[2:0]     C0_DDR4_M_AXI_awprot,
    output[3:0]     C0_DDR4_M_AXI_awqos,
    input           C0_DDR4_M_AXI_awready,
    output[2:0]     C0_DDR4_M_AXI_awsize,
    output          C0_DDR4_M_AXI_awvalid,
    input  [0:0]    C0_DDR4_M_AXI_bid,
    output          C0_DDR4_M_AXI_bready,
    input  [1:0]    C0_DDR4_M_AXI_bresp,
    input           C0_DDR4_M_AXI_bvalid,
    input  [511:0]  C0_DDR4_M_AXI_rdata,
    input  [0:0]    C0_DDR4_M_AXI_rid,
    input           C0_DDR4_M_AXI_rlast,
    output          C0_DDR4_M_AXI_rready,
    input  [1:0]    C0_DDR4_M_AXI_rresp,
    input           C0_DDR4_M_AXI_rvalid,
    output[511:0]   C0_DDR4_M_AXI_wdata,
    output          C0_DDR4_M_AXI_wlast,
    input           C0_DDR4_M_AXI_wready,
    output[63:0]    C0_DDR4_M_AXI_wstrb,
    output          C0_DDR4_M_AXI_wvalid,

    input           c0_ddr4_ui_clk,
    input           c0_ddr4_ui_clk_sync_rst,
    input           c0_init_calib_complete,
    output          c0_ddr4_aresetn,
    input           c0_ddr4_interrupt,

使用APP接口的MIG时，RP_bd应提供如下接口

    output          c0_ddr4_app_correct_en_i,
    input  [51:0]   c0_ddr4_ecc_err_addr,
    input  [7:0]    c0_ddr4_ecc_single,
    input  [7:0]    c0_ddr4_ecc_multiple,

    output [27:0]   c0_ddr4_app_addr,
    output [2:0]    c0_ddr4_app_cmd,
    output          c0_ddr4_app_en,
    output          c0_ddr4_app_hi_pri,
    output [511:0]  c0_ddr4_app_wdf_data,
    output          c0_ddr4_app_wdf_end,
    output [63:0]   c0_ddr4_app_wdf_mask,
    output          c0_ddr4_app_wdf_wren,
    input  [511:0]  c0_ddr4_app_rd_data,
    input           c0_ddr4_app_rd_data_end,
    input           c0_ddr4_app_rd_data_valid,
    input           c0_ddr4_app_rdy,
    input           c0_ddr4_app_wdf_rdy,
    input           c0_dbg_clk,
    input  [511:0]  c0_dbg_bus,
    input           c0_ddr4_ui_clk,
    input           c0_ddr4_ui_clk_sync_rst,
    input           c0_init_calib_complete,

## 仿真方法

我们支持APP和AXI接口的MIG仿真，用户在编写仿真脚本时可以参考demo工程目录下的文件。

简单来说就是要根据接口类型修改文件列表，也就是./usr_files/sim/scripts/top.vivado.v.f文件。

如果是使用APP接口MIG，添加以下三行
	
	${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0.sv
	${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0_ddr4.sv	
	-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f

如果是使用AXI接口MIG，添加以下三行
	
	${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0.sv
	${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0_ddr4.sv
	-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f

另外仿真时只要定义了FAST_SIM宏，则仿真时会采用对应接口的寄存器数组来模拟DDR，加快仿真速度。可参考[说明-进行FPGA云镜像开发的流程](./说明-进行FPGA云镜像开发的流程.md)中demo工程仿真的说明。


