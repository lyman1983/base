FROM ubuntu:14.04

MAINTAINER lyu zhibin <lyuzb@lyuzb.com>

ARG PASSWD=passwd

# 更新源
RUN cp /etc/apt/sources.list /etc/apt/sources.list-bk \
 && { \
 		echo 'deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse'; \
    } > /etc/apt/sources.list \

#设置容器时区为上海，以便和宿主机同步
 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \

#更新到最新系统，并安装常用工具及服务
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y openssh-server openssh-client vim curl wget unzip dos2unix \

#配置ssh及初始化root账号
 && mkdir /var/run/sshd \
 && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
 && echo "root:$PASSWD" | chpasswd \

# 安装supervisor工具
 && sudo apt-get install -y supervisor \
 && sudo mkdir -p /var/log/supervisor \

# 清理安装包
 && rm -rf /var/lib/apt/lists/*

# 添加 supervisord 的配置文件，并复制配置文件到对应目录下面。（supervisord.conf文件和Dockerfile文件在同一路径）
ADD supervisord.conf /etc/supervisor/conf.d

# 容器需要开放SSH 22端口
EXPOSE 22

# 执行supervisord来同时执行多个命令，使用 supervisord 的可执行路径启动服务。
CMD ["/usr/bin/supervisord"]