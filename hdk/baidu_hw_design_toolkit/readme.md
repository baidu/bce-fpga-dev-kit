## 1.目录结构
`Baidu_HW_design_toolkit`提供了制作fpga硬件逻辑所需的环境，您只将自己逻辑所需的相关的文件如rtl代码，ip核，xdc约束等放入指定的路径，然后执行脚本，即可生成用于烧写fpga云服务器的逻辑镜像文件。

`Baidu_HW_design_toolkit`包含了4个子文件夹，分别是common_files和三个demoprj工程。

- common_files存放fpga云服务器工程的一些通用设计。
- `static_fix_dcp`中保存的是工程的静态部分dcp，包括pcie控制器和支持xvc所需的ip core。
- hdl存放了一个`rp_bd_wrapper.v`的rtl文件，这可以算是fpga云服务器工程中静态部分逻辑与动态部分逻辑的一个接口。您要实现的定制逻辑就是`rp_bd_wrapper`中实例化的rp_bd模块。
- Constraints存放了对`rp_bd_wrapper`模块进行ooc综合所需的约束文件。
- ref_xdc存放了fpga云服务器的内存控制器引脚约束。
- sim存放了静态部分逻辑的仿真模型。

*通常情况下，我们不建议您修改common_files目录中的内容。*

每个demo工程文件下下面包含build和`usr_files`两个子文件夹。`usr_files`存放用户的工程设计文件，它包含了5个子文件夹:

- usr_rtl用于存放用户逻辑使用的rtl文件。
- usr_xdc用于存放用户逻辑所需的约束文件。
- usr_ip用于存放用户逻辑所使用的ip xci文件。
- usr\_ip\_resposity用于存放用户自己封装的ip库。
- sim存放了该工程仿真所需的脚本和testbench，一般来说，在单个工程仿真时都需要调用common_files下的静态逻辑仿真模型文件。

build存放制作fpga云服务器逻辑镜像所要执行的脚本，如果您是有经验的用户，可以参考并根据自己的需要修改脚本。

## 2.制作fpga云服务逻辑镜像步骤
`Baidu_HW_design_toolkit`提供了两种方式制作fpga云服务器逻辑镜像。两种方式需要准备不同的设计文件，您可以任选一种自己喜欢的方式。

### 1) Non_IPI流程

这种方式比较类似传统的fpga工程实现方式，您需要准备好动态部分逻辑（也就是`rp_bd_wrapper.rp_bd_i`）的设计文件放入usr_files指定的目录， 然后执行build目录下的run\_nonIPI.tcl脚本。

以prj_testreg工程作为制作逻辑镜像的示范例子，具体步骤如下所示。

*由于默认的`Baidu_HW_design_toolkit/prj_testreg/usr_files`目录里已经包含了demo工程的设计文件，您也可以跳过1~4，直接从步骤5开始，执行脚本体验制作云服务器逻辑镜像的过程。*

1. 用户定制rp_bd所用到的约束文件，需全部拷贝到工具包中`Baidu\_HW_design_toolkit/prj_testreg/usr_files/usr_xdc`目录下。
- 用户定制rp_bd所用到的rtl文件，需全部拷贝到工具包中`Baidu\_HW_design_toolkit/prj_testreg/usr_files/usr_rtl`目录下。
- 用户定制rp_bd所用到的ip core文件，需全部拷贝到工具包中`Baidu_HW_design_toolkit/prj_testreg/usr_files/usr_ip`目录下。
- 用户定制rp_bd所用到的自己封装的ip库，需全部拷贝到工具包中`Baidu_HW_design_toolkit/prj_testreg/usr_files/usr_ip_resposity`目录下。
- 打开`Baidu_HW_design_toolkit/prj_testreg/build/scripts/step_00_setup.tcl`，确认如下四行是否一致
 - set USE\_DDR4\_C0 0
 - set USE\_DDR4\_C1 0
 - set USE\_DDR4\_C2 0
 - set USE\_DDR4\_C3 0
- 进入`Baidu_HW_design_toolkit/prj_testreg/build`目录，执行vivado -mode batch -source ./run_nonIPI.tcl
- 制作fpga云服务逻辑镜像完成，你可以从`Baidu_HW_design_toolkit/prj_testreg/build/proDir/Bitstreams/ver2`文件夹下面看到生成的镜像文件。

### 2) IPI流程
这种方式采用vivado IP Integrator制作云服务逻辑镜像的动态部分逻辑（也就是`rp_bd_wrapper.rp_bd_i`）。你需要准备好IPI的设计文件放入usr_files和build下指定的目录，然后执行build目录下的run\_IPI.tcl脚本。

以`prj_vectoradd_ddr`工程作为制作逻辑镜像的示范例子，具体步骤如下所示。

*由于默认的`Baidu_HW_design_toolkit/prj_vectoradd_ddr/usr_files`目录里已经包含了demo工程的IPI设计文件，您也可以跳过1~4，直接从步骤5开始，执行脚本体验制作云服务器逻辑镜像的过程。*

1. 用户定制rp_bd block design所用到的约束文件，需全部拷贝到工具包中`Baidu_HW_design_toolkit/prj_vectoradd_ddr/usr_files/usr_xdc`目录下。
- 用户定制rp_bd block design所用到的rtl文件，需全部拷贝到工具包中`Baidu_HW_design_toolkit/prj_vectoradd_ddr/usr_files/usr_rtl`目录下。
- 用户定制rp_bd block design所用到的自己封装的ip库，需全部拷贝到工具包中`Baidu_HW_design_toolkit/prj_vectoradd_ddr/usr_files/usr_ip_resposity`目录下。
- 用户定制rp_bd block design所用到的tcl文件，需命名为`rp_bd.tcl`并拷贝到工具包中`Baidu_HW_design_toolkit/prj_vectoradd_ddr/build/scripts`目录下。
- 打开`Baidu_HW_design_toolkit/prj_vectoradd_ddr/build/scripts/step_00_setup.tcl`，确认如下四行是否一致
 - set USE\_DDR4\_C0 1
 - set USE\_DDR4\_C1 1
 - set USE\_DDR4\_C2 1
 - set USE\_DDR4\_C3 1
- 进入`Baidu_HW_design_toolkit/prj_vectoradd_ddr/build`目录，执行vivado -mode batch -source ./run_IPI.tcl
- 制作fpga云服务逻辑镜像完成，你可以从`Baidu_HW_design_toolkit/prj_vectoradd_ddr/build/proDir/Bitstreams/ver2`文件夹下面看到生成的镜像文件。