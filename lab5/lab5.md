# 实验要求

## 基本要求

- [x] 在一台主机（虚拟机）上同时配置Nginx和VeryNginx
  - [x] VeryNginx作为本次实验的Web App的反向代理服务器和WAF
  - [x] PHP-FPM进程的反向代理配置在nginx服务器上，VeryNginx服务器不直接配置Web站点服务
- [x] 使用[Wordpress](https://wordpress.org/)搭建的站点对外提供访问的地址为： [http://wp.sec.cuc.edu.cn](http://wp.sec.cuc.edu.cn/)
- [x] 使用[Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)搭建的站点对外提供访问的地址为： [http://dvwa.sec.cuc.edu.cn](http://dvwa.sec.cuc.edu.cn/)

------

## 安全加固要求

- [x] 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的**友好错误提示信息页面-1**
- [x] [Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的**友好错误提示信息页面-2**
- [ ] 在不升级Wordpress版本的情况下，通过定制[VeryNginx](https://github.com/alexazhou/VeryNginx)的访问控制策略规则，**热**修复[WordPress < 4.7.1 - Username Enumeration](https://www.exploit-db.com/exploits/41497/)
- [x] 通过配置[VeryNginx](https://github.com/alexazhou/VeryNginx)的Filter规则实现对[Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)的SQL注入实验在低安全等级条件下进行防护

------

## VeryNginx配置要求

- [x] [VeryNginx](https://github.com/alexazhou/VeryNginx)的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的**友好错误提示信息页面-3**
- [x] 通过定制VeryNginx的访问控制策略规则实现：
  - [x] 限制DVWA站点的单IP访问速率为每秒请求数 < 50
  - [x] 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
  - [x] 超过访问频率限制的请求直接返回自定义**错误提示信息页面-4**
  - [ ] 禁止curl访问

# 实验过程

1. Nginx安装

   ```shell
   sudo apt update                #下载nginx
   sudo apt install nginx
   cd /etc/nginx/sites-enabled             #修改端口号
   sudo vim /etc/nginx/sites-enabled/default
   apt-cache search libssl             #查看版本名称
   ```

<img src="pic\1.png" style="zoom:80%;" />

2. VeryNginx安装

```shell
sudo git clone https://github.com/alexazhou/VeryNginx   #注意加sudo
cd VeryNginx
      
sudo apt install gcc				# 安装依赖库
sudo apt install libssl1.0-dev
sudo apt install libpcre3 libpcre3-dev
sudo apt install make
sudo apt-get install zlib1g-dev
python3 install.py install
```

报错，经过询问同学，重新安装依赖库

<img src="pic\2.png" style="zoom:80%;" />

```shell
# 安装依赖
sudo apt-get update
sudo apt-get install python3
sudo apt-get install libpcre3 libpcre3-dev libssl-dev build-essential
sudo apt-get install libssl1.0-dev
sudo apt-get install zlib1g-dev

# 重新再尝试安装
sudo python3 install.py install
```

<img src="pic\4.png" style="zoom:80%;" />

```shell
sudo vim nginx.conf              #修改端口号为88，防撞

adduser nginx			# 添加用户
sudo /opt/verynginx/openresty/nginx/sbin/nginx	#启动服务，启动后本地web访问localhost:88

sudo /opt/verynginx/openresty/nginx/sbin/nginx -s stop	#停止服务
sudo /opt/verynginx/openresty/nginx/sbin/nginx -s reload	#重启服务
```

<img src="pic\3.png" style="zoom:50%;" />

<img src="pic\5.png" style="zoom:70%;" />

修改veryngix的配置文件

```shell
sudo vim /opt/verynginx/openresty/nginx/conf/nginx.conf
```

之后重新启动

```shell
sudo /opt/verynginx/openresty/nginx/sbin/nginx
```

访问http://192.168.56.101:88/verynginx/index.html。用户名密码均为verynginx 

<img src="pic\6.png" style="zoom:70%;" />

3. WordPress 4.7安装

下载mysql、php和相关扩展

```shell
# 安装数据库
$ sudo apt install mysql-server
$ sudo mysql -u root -p	        #检查是否正常运行，默认下无密码

#安装php和相关扩展
$ sudo apt install php-fpm php-mysql
$ sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
$ sudo systemctl restart php7.2-fpm
```

<img src="pic\7.png" style="zoom:70%;" />

数据库支持

```shell
# mysql新建数据库
$ sudo mysql -u root -p
> CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
> GRANT ALL ON wordpress.* TO 'wpuser'@'localhost' IDENTIFIED BY 'test';
> FLUSH PRIVILEGES;
> EXIT;
```

<img src="pic\8.png" style="zoom:70%;" />

下载 wordpress

```shell
cd /tmp

# 下载实验指定版本安装包
sudo wget https://github.com/WordPress/WordPress/archive/4.7.zip

# 解压
sudo apt install unzip
unzip -o 4.7.zip

sudo mv WordPress-4.7 wordpress
```

建立Apache与MySQL的连接

```shell
sudo apt-get install phpmyadmin -y    #会涉及配置选项，在虚拟机中做，直接按回车
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo service mysql restart
sudo systemctl restart apache2.service
sudo /etc/init.d/apache2 status
```

<img src="pic\9.png" style="zoom:70%;" />

配置WordPress数据库

```shell
sudo mysql -u root -p
CREATE DATABASE wordpress;	#创建数据库
CREATE USER wordpressusers;	#创建管理员
SET PASSWORD FOR wordpressusers = PASSWORD("1234");	#设置密码
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressusers IDENTIFIED BY "1234";	#设置权限
FLUSH PRIVILEGES;	#生效配置
exit
```

访问 http://wp.sec.cuc.edu.cn

<img src="pic\10.png" style="zoom:70%;" />

4. DVWA安装

   下载安装包（重做了一次实验，第二次是从官网上下载之后传进虚拟机的，和第一次命名上有些细节差别，主题过程相似，不赘述）

   ```shell
   cd /tmp
   git clone https://github.com/ethicalhack3r/DVWA
   sudo cp -r /tmp/DVWA /var/www/html
   ```

   新建数据库

```shell
sudo mysql -u root -p

> CREATE DATABASE dvwa DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
> GRANT ALL ON dvwa.* TO 'dvwauser'@'localhost' IDENTIFIED BY 'test';
> FLUSH PRIVILEGES;
> EXIT;

sudo systemctl restart mysql
```

<img src="pic\11.png" style="zoom:70%;" />

修改dvwa数据库相关和其他设置

```shell
cd /var/www/html/dvwa      #（前一次实验失败，重新下载后文件命名为dvwa)
sudo cp config/config.inc.php.dist config/config.inc.php
sudo vim /var/www/html/DVWA/config/config.inc.php 
        
        # 修改以下内容
        $_DVWA[ 'db_database' ] = 'dvwa';
        $_DVWA[ 'db_user' ]     = 'dvwauser';
        $_DVWA[ 'db_password' ] = 'test';

# 修改文件属主
sudo chown -R www-data:www-data /var/www/html/dvwa

# 修改 nginx 相关配置
sudo vim /etc/nginx/conf.d/default.conf

        server {
                listen 5566;
                server_name  dvwa.sec.cuc.edu.cn;

                root /var/www/html/dvwa;
                index index.html index.htm index.php index.nginx-debian.html;

                location / {
                        try_files $uri $uri/ = 404;
                        }

                location ~ \.php$ {
                        include snippets/fastcgi-php.conf;
                        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
                        }
                        }

# 修改php相关设置
sudo vim  /etc/php/7.2/fpm/php.ini

        # 修改以下内容
        allow_url_include = On

sudo systemctl restart php7.2-fpm	#重启php，使配置生效
sudo systemctl restart nginx	#重启nginx，使配置生效
```

访问dvwa.sec.cuc.edu.cn:5566

<img src="pic\12.png" style="zoom:70%;" />

5. 设置VeryNginx

   修改nginx的配置文件

   ```shell
   sudo vim /etc/nginx/sites-enabled/default
   ```

<img src="pic\13.png" style="zoom:70%;" />

通过 VeryNginx进行相关设置<img src="pic\14.png" style="zoom:70%;" />

<img src="pic\15.png" style="zoom:70%;" />

6. 安全加固（修改 Matcher、Response、Filter）

   a. 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的友好错误提示信息页面-1

   matcher设置使host符合IP地址的正则表达式

   response设置回应

   设置filter，action是block，选择设置的回答

   <img src="pic\16.png" style="zoom:70%;" />

   b. Damn Vulnerable Web Application (DVWA)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-2

   matcher设置使host符合DVWA的域名，IP不等于白名单

   其他两项类似a

   <img src="pic\17.png" style="zoom:70%;" />

   d. 通过配置VeryNginx的Filter规则实现对Damn Vulnerable Web Application (DVWA)的SQL注入实验在低安全等级条件下进行防护

   matcher设置sql注入会用到的select语句、or、where

   其他两项类似a

   <img src="pic\18.png" style="zoom:70%;" />

7. VeryNginx配置要求

   a. VeryNginx的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面

   matcher设置限制DVWA站点的单IP

   其他两项类似a

   <img src="pic\19.png" style="zoom:70%;" />

   

   b. 通过定制VeryNginx的访问控制策略规则实现：

   * 访问速率为每秒请求数 < 50

   * 限制Wordpress站点的单IP访问速率为每秒请求数 < 20

   * 超过访问频率限制的请求直接返回自定义错误提示信息页面-4

   前两项修改Frequency Limit即可，第三项修改Response，步骤类似前面

   * ban一直不成功

# 实验结论

   * 正向代理是在我们无法直接访问某网站时，通过代理服务器来实现访问的方式。
   * 反向代理就是把大量的访问任务分配到各个分服务器。

   

   