# 工具说明

此工具用于在vm hypervisor端探查FPGA的插卡状态、温度等信息，在vm guest内部亦能正常使用。

FPGA插卡状态可以通过lspci检查相应Vendor/Device ID得出。
> 开发环境 10ee:9038
> RSA 10ee:8038
> CNN 1d22:2011

FPGA温度读取脚本藉由一个C语言写成的小程序mmap映射FPGA BAR空间对应之sysfs路径（如FPGA的BAR0对应到 `/sys/devices/pci0000:00/0000:00:01.0/0000:0c:00.0/resource0`），读取温度寄存器的值，并换算成摄氏温度。

# 使用方法

* `is_fpga_installed.sh` 用于获取FPGA插卡状态，输出`IS_FPGA_INSTALLED:1`表示已插卡，输出`IS_FPGA_INSTALLED:0`表示未插卡。
<pre>
[root@cq02-bcc-online-com2-418.cq02.baidu.com miaotianxiang]# ./is_fpga_installed.sh
IS_FPGA_INSTALLED:1
</pre>

* `get_fpga_temperature.sh` 用于获取FPGA的温度，输出类似`FPGA_TEMPERATURE:45.32`。**如机器未插卡或运行过程发生异常，脚本无打印输出，并会令返回值为1。在vm关机/重启或hypervisor加载驱动时，PCIe链路可能不稳定，有一定几率导致温度寄存器读出值为64位全ff，此时脚本会输出一个仿冒的温度`FPGA_TEMPERATURE:37.0`。**
<pre>
[root@cq02-bcc-online-com2-418.cq02.baidu.com miaotianxiang]# ./get_fpga_temperature.sh
FPGA_TEMPERATURE:45.32
</pre>

