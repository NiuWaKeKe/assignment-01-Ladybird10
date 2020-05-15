# 实验目的

- [ ] 任务一：用bash编写一个图片批处理脚本，实现以下功能：
  - [x] 支持命令行参数方式使用不同功能
  - [x] 支持对指定目录下所有支持格式的图片文件进行批处理
  - [x] 支持以下常见图片批处理功能的单独使用或组合使用
    - 支持对jpeg格式图片进行图片质量压缩
    - 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
    - 支持对图片批量添加自定义文本水印
    - 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
    - 支持将png/svg图片统一转换为jpg格式图片



------



- [ ] 任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
  - 2014世界杯运动员数据
    - [x] 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员**数量**、**百分比**
    - [ ] 统计不同场上位置的球员**数量**、**百分比**
    - [x] 名字最长的球员是谁？名字最短的球员是谁？
    - [x] 年龄最大的球员是谁？年龄最小的球员是谁？



------



- [ ] 任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
  - Web服务器访问日志
    - [x] 统计访问来源主机TOP 100和分别对应出现的总次数
    - [x] 统计访问来源主机TOP 100 IP和分别对应出现的总次数
    - [x] 统计最频繁被访问的URL TOP 100
    - [x] 统计不同响应状态码的出现次数和对应百分比
    - [x] 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
    - [x] 给定URL输出TOP 100访问来源主机

# 实验过程Ⅰ

1. 单独建立文件夹

   ```shell
   mkdir lab4
   cd lab4
   ```

2. 编写shell文件

   ```shell
   vim task1.sh
   ```

3. 从本地向linux上传几张图片（利用sftp）

4. * help信息

<img src="PIC\4-1-1.png" style="zoom:80%;" />

* 对jpeg格式图片进行图片质量压缩

<img src="PIC\4-1-2-1.png" style="zoom:80%;" />

<img src="PIC\4-1-2-2.png" style="zoom:80%;" />

* 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率

<img src="PIC\4-1-3.png" style="zoom:80%;" />

* 批量添加自定义文本水印

<img src="PIC\4-1-4.png" style="zoom:80%;" />

* 批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）

<img src="PIC\4-1-5.png" style="zoom:80%;" />

* 将png/svg图片统一转换为jpg格式图片

<img src="PIC\4-1-6.png" style="zoom:80%;" />

# 实验过程Ⅱ

1. 准备工作

   ```shell
   wget https://c4pr1c3.github.io/LinuxSysAdmin/exp/chap0x04/worldcupplayerinfo.tsv
   ```

2. * HELP信息

<img src="PIC\4-2-1.png" style="zoom:80%;" />

* 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员**数量**、**百分比**

<img src="PIC\4-2-2.png" style="zoom:80%;" />

* 名字最长的球员是谁？名字最短的球员是谁？

  <img src="PIC\4-2-6.png" style="zoom:80%;" />

  <img src="PIC\4-2-7.png" style="zoom:80%;" />

* 年龄最大的球员是谁？年龄最小的球员是谁？

<img src="PIC\4-2-3.png" style="zoom:80%;" />

<img src="PIC\4-2-4.png" style="zoom:80%;" />

# 实验过程Ⅲ

* 经验教训：千万不能少打空格！！！

* HELP

  <img src="PIC\4-3-1.png" style="zoom:80%;" />

* 统计访问来源主机TOP 100和分别对应出现的总次数

  [结果1]([https://github.com/20LinuxManagement/assignment-01-Ladybird10/tree/master/lab4/outcome/3-1.txt)

* 统计访问来源主机TOP 100 IP和分别对应出现的总次数

  [结果2]([https://github.com/20LinuxManagement/assignment-01-Ladybird10/tree/master/lab4/outcome/3-2.txt)

* 统计最频繁被访问的URL TOP 100

  [结果3]([https://github.com/20LinuxManagement/assignment-01-Ladybird10/tree/master/lab4/outcome/3-3.txt)

* 统计不同响应状态码的出现次数和对应百分比

  <img src="PIC\4-3-2.png" style="zoom:80%;" />

* 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数

  <img src="PIC\4-3-3.png" style="zoom:80%;" />

* 给定URL输出TOP 100访问来源主机

  [结果6]([https://github.com/20LinuxManagement/assignment-01-Ladybird10/tree/master/lab4/outcome/3-6.txt)
