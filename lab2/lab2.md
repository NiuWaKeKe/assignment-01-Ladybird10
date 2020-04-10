# 实验环境

- Ubuntu 18.04 Server 64bit
- 在[asciinema](https://asciinema.org/)注册一个账号，并在本地安装配置好asciinema

# 实验要求

- [x] 确保本地已经完成**asciinema auth**，并在[asciinema](https://asciinema.org/)成功关联了本地账号和在线账号
- [x] 上传本人亲自动手完成的**vimtutor**操作全程录像
- [x] 在自己的github仓库上新建markdown格式纯文本文件附上asciinema的分享URL

# 实验过程

1. 安装asciinema并关联账号

```shell
sudo apt update
sudo apt install asciinema
asciinema auth
```

2. 开始录制

```shell
asciinema rec -i 2 les1.cast
vimtutor
```

3. 第一讲

   [第一讲操作录屏](https://asciinema.org/a/IItwAg9KEuFNaGo6CKF7DuBsV)

4. 第二讲

   [第二讲操作录屏](https://asciinema.org/a/Rxswfr3Z6IQGGleF9FmdRWqtb)

5. 第三讲——第七讲

   （每一讲分开录太麻烦了，后几讲统一录屏了）

   [第三至七讲操作录屏](https://asciinema.org/a/YOsiKgAx5Ad0LfjbH4jCj12gA)

中文版vimtutor指导

> https://www.cnblogs.com/YooHoeh/p/10659695.html

# 自查清单

- 你了解vim有哪几种工作模式？
  - 命令模式
  - 输入模式
  - 编辑模式
- Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？
  - 向下移动光标10行：10$
  - 到文件结束行：G
  - 到文件开始行：gg
  - 文件中的第N行：N+G
- Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？
  - 删除单个字符：x
  - 单个单词：dw
  - 从当前光标位置一直删除到行尾：d$
  - 单行：d1$
  - 当前行开始向下数N行：dN$
- 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？
  - 在vim中快速插入N个空行：No
  - 快速输入80个-: 80i-
- 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？
  - 撤销最近一次编辑操作:u
  - 重做最近一次被撤销的操作: ctrl+R
- vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？
  - 剪切粘贴单个字符: dp
  - 单个单词:dwp
  - 单行:ddp
  - 选中文本进行复制：命令模式下按v进入Visual模式，复制文本，y复制，ESC回到normal模式，p粘贴

- 为了编辑一段文本你能想到哪几种操作方式（按键序列）？
  - vim 文件名
  - i 编辑
  - ESC回到normal模式
  - :wq 保存并退出
- 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？
  - Ctrl+G
- 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？
  - 关键词搜索: /xxxx 或 ?xxxx
  - 忽略大小写的匹配搜索：:set ic
  - 高亮显示：set hls is
  - 批量替换：:%s/old/new/g
- 在文件中最近编辑过的位置来回快速跳转的方法？
  - 向前：Ctrl+I
  - 向后：Ctrl+O
- 如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }
  - 光标移动到该括号后按%
- 在不退出vim的情况下执行一个外部程序的方法？
  - !+外部命令
- 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？
  - 使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法：:help
  - 分屏窗口移动光标：Ctrl+W