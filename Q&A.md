* **Q: 经百度云控制台webvnc登录桌面环境后，vivado调试时波形图不能正确显示，并可见java运行时异常，该如何解决？**
  * A: 出现此现象的原因可能是vivado某些显示功能和百度云webvnc存在冲突，可通过自行在虚拟机实例内安装vnc服务以获取桌面环境绕过，具体步骤如下。第一步，执行`sudo yum -y install tigervnc-server`安装vnc服务器；第二步，执行`vncserver -geometry 1920x1080`启动一个X DISPLAY，此处分辨率可按需调整，另注意首次启动时需要设置vnc密码；第三步，购买一个EIP（公网IP）；第四步，在本地vnc客户端（如vnc viewer）通过EIP+端口号（首个X DISPLAY一般为5901）连接虚拟机实例内的vnc服务器获取桌面环境；第五步，启动vivado进行波形图调试。

![qa_vivado_waveform](./sdk/doc/img/qa_vivado_waveform.png)
![qa_vivado_java_exception](./sdk/doc/img/qa_vivado_java_exception.png)

* **Q: NMI问题**
  * A: TBD

* **Q: No irq handler for vector (irq -1)**
  * A: TBD