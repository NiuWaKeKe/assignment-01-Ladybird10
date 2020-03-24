# 实验环境

- Virtualbox
- Ubuntu 18.04 Server 64bit

# 实验目的

- [x] 如何配置无人值守安装iso并在Virtualbox中完成自动化安装。
- [x] Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？
- [x] 如何使用sftp在虚拟机和宿主机之间传输文件？

# 实验步骤

1. 有人值守的安装一台ubuntu

<img src="pic\1.JPG" style="zoom:50%;" />

2. 更改网络设置

<img src="pic\2.png" style="zoom:50%;" />

<img src="pic\3.png" style="zoom:50%;" />

后由于开启ssh原因，更换了网卡2和网卡3的顺序

3. 再新建一台虚拟设备，以备无人值守安装

<img src="pic\4.png" style="zoom:50%;" />

4. 开启SSH，方便复制粘贴

   > 如何在ubuntu上安装ssh服务：https://jingyan.baidu.com/article/54b6b9c08ff5c42d583b473c.html

   

* apt-get太慢了，更换为清华的源。更换后可能会遇到lock问题（也就是之前运行过的apt-get进程没有kill，和新的要执行的lock了），要么杀死原来在运行的apt-get进程，要么重启（推荐重启）

> 更换源的参考：https://www.woozee.com.cn/article/25.html

<img src="pic\6.png" style="zoom:50%;" />

## 

## 制作无人值守适用的iso镜像

* step 1

```shell
# 在当前用户目录下创建一个用于挂载iso镜像文件的目录
mkdir loopdir
# 挂载iso镜像文件到该目录
mount -o loop ubuntu-18.04.4-server-amd64.iso loopdir
# 创建一个工作目录用于克隆光盘内容
mkdir cd
# 同步光盘内容到目标工作目录
# 一定要注意loopdir后的这个/，cd后面不能有/
rsync -av loopdir/ cd
# 卸载iso镜像
umount loopdir
# 进入目标工作目录
cd cd/
# 编辑Ubuntu安装引导界面增加一个新菜单项入口
vim isolinux/txt.cfg
```

在mount命令时，会发现直接挂载是不现实的，因为iso都没有传递上来

<img src="pic\5.png" style="zoom:80%;" />

### SFTP的使用

利用sftp实现文件的上传。注意上传要切换到文件所在的本地目录去，然后linux也切换到目的地

```shell
sftp 用户名@IP #连接
ls #查看linux的目录
lls #查看本地的目录
cd #切换linux的目录
lcd #切换linux的目录
put 文件名 #上传
get 文件名 #下载
```

<img src="pic\9.png" style="zoom:80%;" />

<img src="pic\10.png" style="zoom:80%;" />



* step 2

  进入txt.cfg编辑【记得转换为root权限下】，添加以下内容到该文件后强制保存退出（:!wq，一定用这个方式，用不加！的会报错）

```
label autoinstall
  menu label ^Auto Install Ubuntu Server
  kernel /install/vmlinuz
  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet
```

<img src="pic\11.png" style="zoom:80%;" />

* step 3

  将老师仓库中提供的[ubuntu-server-autoinstall.seed](https://github.com/c4pr1c3/LinuxSysAdmin/blob/master/exp/chap0x01/cd-rom/preseed/ubuntu-server-autoinstall.seed)拷贝到主机上

  并通过sftp传输到`~/cd/preseed`下面

  然而在进行常规操作时，发现权限不够，遂查询修改权限方式，更改文件夹权限。修改之后即可成功

  ```shell
  sftp> lcd D:
  sftp> lls
  sftp> cd cd
  sftp> ls
  sftp> cd preseed
  sftp> ls
  sftp> put ubuntu-server-autoinstall.seed
  ```

  

  <img src="pic\12.png" style="zoom:80%;" />

  <img src="pic\13.png" style="zoom:80%;" />

<img src="pic\14.png" style="zoom:80%;" />

<img src="pic\15.png" style="zoom:80%;" />

更改文件夹权限

> https://blog.csdn.net/oljuydfcg/article/details/91447757

* step 4

  修改isolinux/isolinux.cfg，增加内容`timeout 10`

  当然也需要修改权限（将”isolinux“的位置改为“ * ”可以一次性修改所有文件夹的权限）

  <img src="pic\16.png" style="zoom:80%;" />

<img src="pic\17.png" style="zoom:80%;" />

* step 5

  生成iso

  ```shell
  # 重新生成md5sum.txt
  cd ~/cd && find . -type f -print0 | xargs -0 md5sum > md5sum.txt
  
  # 封闭改动后的目录到.iso
  IMAGE=custom.iso
  BUILD=~/cd/
  
  mkisofs -r -V "Custom Ubuntu Install CD" \
              -cache-inodes \
              -J -l -b isolinux/isolinux.bin \
              -c isolinux/boot.cat -no-emul-boot \
              -boot-load-size 4 -boot-info-table \
              -o $IMAGE $BUILD
  
  # 如果目标磁盘之前有数据，则在安装过程中会在分区检测环节出现人机交互对话框需要人工选择
  ```

  <img src="pic\18.png" style="zoom:80%;" />

* step 6

  将iso文件利用sftp下载到本地（注意两边地址的对应）

  <img src="pic\19.png" style="zoom:80%;" />

* step 7 

  启动无人值守的安装，会发现主页有自动安装的选项。经记录，自动安装过程从16：43持续到16：49

<img src="pic\20.png" style="zoom:80%;" />

<img src="pic\21.png" style="zoom:80%;" />

## 网卡自动启动并获取IP

* 根据配置文件中的内容，可获得用户名与密码，登陆，输入ifconfig，可以看到ip地址自动分配了

<img src="pic\22.png" style="zoom:80%;" />

# 实验问题

1. 重新安排了一个虚拟机，再次ssh登陆时出现了

<img src="pic\7.png" style="zoom:50%;" />

以下网站提出了ssh连接提示“REMOTE HOST IDENTIFICATION HAS CHANGED! ”解决办法

> https://cloud.tencent.com/developer/article/1508166

（文档在windows机器中alienware中的.ssh文件下）

# 实验结论

| 原始                                                         | 修改                                                         | 意义                                           |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------- |
| \#### Contents of the preconfiguration file (for stretch)    | \#### Contents of the preconfiguration file (for xenial)     | 对于Ubuntu bionic代表Ubuntu 18.04,             |
| 无                                                           | d-i localechooser/supported-locales multiselect en_US.UTF-8, zh_CN.UTF-8  d-i pkgsel/install-language-support boolean false | 国家地区语言                                   |
| \#d-i netcfg/link_wait_timeout string 10                     | d-i netcfg/link_wait_timeout string 5                        | 链路检测等待超时时间                           |
| \#d-i netcfg/dhcp_timeout string 60                          | d-i netcfg/dhcp_timeout string 5                             | DHCP服务器超时时间                             |
| \#d-i netcfg/disable_autoconfig boolean true                 | d-i netcfg/disable_autoconfig boolean true                   | 手动配置网络                                   |
| d-i netcfg/get_hostname string unassigned-hostname` `d-i netcfg/get_domain string unassigned-domain | d-i netcfg/get_hostname string CUC-Server` `d-i netcfg/get_domain string cuc.edu.cn | 设置主机名和域名                               |
| #d-i netcfg/hostname string somehost                         | d-i netcfg/hostname string cucserver                         | 强制设置主机名为cucserver                      |
| #d-i passwd/user-fullname string Ubuntu User` `#d-i passwd/username string ubuntu` `#d-i passwd/user-password password insecure` `#d-i passwd/user-password-again password insecure` `#d-i user-setup/allow-password-weak boolean true | d-i passwd/user-fullname string CUC User` `d-i passwd/username string cuc` `d-i passwd/user-password password resu` `d-i passwd/user-password-again password resu  d-i user-setup/allow-password-weak boolean true | 创建用户，设置用户名及密码并确认为弱密钥       |
| #d-i partman-auto/init_automatically_partition select biggest_free | d-i partman-auto/init_automatically_partition select biggest_free | 若系统有可用空间，则可以选择仅对该空间进行分区 |
| #d-i partman-auto-lvm/guided_size string max                 | d-i partman-auto-lvm/guided_size string max                  | LVM 分区方式，设置逻辑卷的大小为最大           |
| d-i partman-auto/choose_recipe select atomic                 | d-i partman-auto/choose_recipe select multi                  | 分区方式                                       |
| #d-i apt-setup/use_mirror boolean false                      | d-i apt-setup/use_mirror boolean false                       | 禁止网络镜像                                   |
| tasksel tasksel/first multiselect ubuntu-desktop             | tasksel tasksel/first multiselect server                     | 安装 server 软件包                             |
| #d-i pkgsel/include string openssh-server build-essential    | d-i pkgsel/include string openssh-server                     | 安装 OpenSSH Server                            |
| #d-i pkgsel/upgrade select none                              | d-i pkgsel/upgrade select none                               | 禁止自动升级包                                 |
| #d-i pkgsel/update-policy select none                        | d-i pkgsel/update-policy select unattended-upgrades          | 自动安装安全类更新                             |