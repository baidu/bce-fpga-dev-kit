# 百度FPGA云开发环境软硬件工具包

[![Join the chat at https://gitter.im/bce-fpga-dev-kit/Lobby](https://badges.gitter.im/bce-fpga-dev-kit/Lobby.svg)](https://gitter.im/bce-fpga-dev-kit/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## 目录

1. [概览](#overview)
1. [已支持/待开发特性列表](#featurelist)
1. [ChangeLog](#changelog)
1. [HDK简介](#hdk)
1. [SDK简介](#sdk)
1. [联系交流](#contact)

<a name="overview"></a>
## 概览

百度FPGA云服务器是配备了现场可编程门阵列(FPGA)的虚拟机实例。每个实例提供了一片20nm Xilinx UltraScale FPGA，其中包含多达150万个逻辑单元和5520个数字信号处理(DSP)引擎，并独享8GB板载四通道DDR4-2400 ECC内存以及与主机间的PCIe Gen3 x8链路。FPGA丰富的逻辑计算资源和高速IO接口，赋予了您的应用充足的性能提升空间，尤为适合解决诸如基因检测、财务分析这类涉及高性能计算(HPC)的复杂科学、工程问题。使用百度FPGA云服务器，您无需耗费精力设计、购买或运维硬件，可以节省这些额外步骤带来的成本。

您可以在百度FPGA云开发环境上快速灵活地对软硬件进行编程，通过协同设计来为您的应用创建自定义加速。您也可以选择云市场上百度或第三方厂商提供的成熟普适加速方案，如神经网络计算、多媒体处理、数据加解密等，参照简易步骤在FPGA云服务器上部署后轻松提升应用性能。

百度FPGA云开发环境旨在为开发者提供一个稳定可靠、便捷易用的FPGA软硬件编程环境。它分为HDK(Hardware Development Kit)和SDK(Software Development Kit)两部分，其中囊括了开发、模拟、调试和编译代码所需的各种资源。基于此，开发者能轻松构建FPGA自定义逻辑，并可将已有设计顺利移植到百度FPGA云服务器。

<a name="featurelist"></a>
## 已支持/待开发特性列表

### 已支持特性

### 待开发特性

* 更完善的自定义逻辑仿真支持
* 多PCIe Function支持
* SDAccel开发环境支持
* FPGA云市场支持
* RP端AXI-Stream接口支持
* 更多型号FPGA如Xilinx VU9P和Altera S10支持

<a name="changelog"></a>
## ChangeLog

**百度云会不定期升级FPGA静态逻辑，并对应更新该工具包，其中可能包含新增特性支持或Bug修复。升级后旧版本的工具包将不再被支持。请关注本节更新公告，并及时从[https://github.com/Cwndmiao/bce-fpga-dev-kit/releases](https://github.com/Cwndmiao/bce-fpga-dev-kit/releases)下载最新版本的工具包。**

| 版本 | 新增特性支持 | Bug修复 | 已知问题 |
| :--: | :----------- | :------ | :------- |
| V1.5.1 | * 增加了MIG AXI ID宽度的动态调整支持 </br> * 增加了动态逻辑自动化仿真脚本 | | |
| V1.5 | * 将用户动态逻辑寄存器调整到独占的BAR 2，同时大小扩充为4MB | | |
| V1.4 | * 管理工具bce_fpga_mgmt_tool支持ResetPartialLogic/ResetStaticLogic | * 修复了V1.3中“prj_rpaximaster示例工程在虚拟机中可能出现DMA失败”的问题 </br> * 修复了V1.3中“调试时Vivado中波形图显示异常”的问题 | |
| V1.3 | * 支持管理工具bce_fpga_mgmt_tool | | * prj_rpaximaster示例工程在虚拟机中可能出现DMA失败 </br> * 调试时Vivado中波形图显示异常 |
| V1.2 | * 支持rpaximaster </br> * 一个示例工程prj_rpaximaster | | |
| V1.1 | * 支持仿真环境 </br> * 一个示例工程prj_testreg </br> * 一个示例工程prj_vectoradd_ddr | | |
| V1.0 | * 初始邀测版本，仅具备基本功能 </br> * 支持XVC调试 </br> * 支持通过tcl脚本编译示例工程 </br> * 一个示例工程prj_vectoradd_ram | | |

<a name="hdk"></a>
## HDK简介

[HDK](./hdk)提供了通用的FPGA自定义逻辑框架，编程时只需支持标准的AXI、AXI-lite总线即可访问板卡上的各种资源，开发者可将精力集中于自定义功能逻辑部分以体现其核心价值。为了方便开发者上手，HDK中还提供了各种示例工程，介绍在百度FPGA云开发环境中使用DDR、DMA、HLS、ILA、VIO的方法，进行逻辑仿真和工程实现的流程，以及在线配置和模拟调试的具体步骤。基于HDK的开发过程没有过多限制，开发者只需将自定义逻辑用到的RTL、IP、约束等放入指定目录，然后执行相应的流程脚本即可。此外，百度FPGA云开发环境还支持IP Integrator，开发者可在设计中直观便捷地集成各种功能的IP 。

<a name="sdk"></a>
## SDK简介

[SDK](./sdk)为FPGA自定义逻辑提供了运行时环境支持，其中包含Linux内核驱动、基础低层C风格API和管理工具。参照SDK中的示例代码，开发者能快速掌握如何使用寄存器、中断、DMA等并对FPGA自定义逻辑进行管理。开发者亦能基于SDK自行开发，暴露高阶API，按需实现高级功能。

<a name="contact"></a>
## 联系交流

**建议您在使用百度FPGA云开发环境前仔细阅读HDK和SDK目录下的使用文档。如果您在使用百度FPGA云开发环境的过程中遇到了任何问题，请首先参考[Q&A](./Q&A.md)，其中罗列了一部分已知问题的解决方法。**

如果您有任何百度FPGA云开发环境相关的Bug报告或发展建议，请通过以下任一方式联系百度云，我们会尽早回复。

* 在[https://github.com/Cwndmiao/bce-fpga-dev-kit/issues](https://github.com/Cwndmiao/bce-fpga-dev-kit/issues)提交Github Issues
* 在[https://gitter.im/bce-fpga-dev-kit/Lobby](https://gitter.im/bce-fpga-dev-kit/Lobby)留言
* 发送邮件至<a href="mailto:miaotianxiang@baidu.com">miaotianxiang</a>或<a href="mailto:ruanyuan@baidu.com">ruanyuan</a>

