# 开机自启动项管理

## 实验目的

* [x] 动手实践Systemd

* [x] 参照第2章作业的要求，完整实验操作过程通过asciinema进行录像并上传，文档通过github上传

## 实验参考

- [Systemd 入门教程：命令篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)

- [Systemd 入门教程：实战篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

  

### Systemd - 特性

  - 提供了积极的（服务、进程）并行化启动能力
  - 使用socket 和 D-Bus 机制来激活启动服务
  - 提供了按需启动守护进程能力
  - 实现了基于事务风格依赖管理的服务控制逻辑
  - 使用Linux的cgroup机制管理进程
  - 支持快照和还原
  - 维护挂载和自动挂载点

### Systemd - 争议

- 激进的设计
  - 重新发明了一堆历史悠久的核心服务(syslog, ntp, cron, fstab, dhcpcd等等)，虽然是简化功能和配置，但有经验的系统管理员更信赖他们熟悉的服务（尽管配置较为复杂）
  - 作为系统的1号进程，承载的功能太多：单点故障风险集中、不符合UNIX设计哲学***[KISS](http://sec.cuc.edu.cn/huangwei/wiki/teaching_basic_how_to_programming.html)***
  - 不遵循 POSIX 标准，无法移植到Linux之外的平台
- 过快的开发迭代
  - 代码质量不高
  - 不考虑向后兼容
  - 频繁变更设计和接口

## 实验过程

1. 下载安装apache

   ```shell
   sudo apt-get update
   sudo apt-get install apache2
   sudo /etc/init.d/apache2 restart
   ```

2.  命令篇：https://asciinema.org/a/xzem4nFRYK2SyQjmedol1jjaT

3. 实战篇：https://asciinema.org/a/OZRGXPQt6bXwYBifsDgqCuYhl

   因为没有安装httpd，所以命令里更换成了apache2

## 实验结果（自查清单）

* 如何添加一个用户并使其具备sudo执行程序的权限？
  * 创建用户：sudo adduser XXX 
  * sudo： sudo usermod -G sudo -a XXX

* 如何将一个用户添加到一个用户组？
  
```shell
  usermod -a -G groupA user
  ```
  
* 如何查看当前系统的分区表和文件系统详细信息？
  * 分区情况：fdisk -l
  * 文件系统详细信息：df -lh

* 如何实现开机自动挂载Virtualbox的共享目录分区？
  * Windows创建文件夹

  * 在虚拟机处选择共享文件夹【NO自动挂载】

  * 新建LINUX共享文件夹

    ```shell
    mkdir /mnt/share
    ```

  * 挂载

    ```shell
    sudo mount -t vboxsf share [WINDOWS目录] /mnt/share/[LINUX目录]
    ```

  * 开机自动挂载

    ```shell
    sudo vim /etc/fstab
    ```

  * 文件末添加(记得重启)

    ```shell
    share[共享名] /mnt/share/[LINUX目录] vboxsf defaults 0 0
    ```

    

* 基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？

```shell
lvextend -L +50M /dev/datavg/datalv #扩容
lvreduce -L -50M /dev/datavg/datalv #缩减
```

* 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？
  * 修改文件中的Service区块
  * 令Restart=always
  * 重新加载配置，重新启动