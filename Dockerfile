FROM ubuntu:18.04

MAINTAINER lyu zhibin <lyuzb@lyuzb.com>

ARG PASSWD=passwd

# 更新源
RUN cp /etc/apt/sources.list /etc/apt/sources.list-bk \
 && { \
		echo 'deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse'; \
    } > /etc/apt/sources.list \

#更新到最新系统，并安装常用工具及服务
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y openssh-server openssh-client vim curl wget unzip dos2unix locales tzdata \

#更新时区为上海
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \

# 安装并设置字符编码
 && locale-gen zh_CN.UTF-8 \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
 && { \
		echo 'export LANG=zh_CN.UTF-8'; \
		echo 'export LANGUAGE=zh_CN:zh'; \
		echo 'export LC_ALL=zh_CN.UTF-8'; \
	} >> /etc/profile \

#配置ssh及初始化root账号
 && mkdir /var/run/sshd \
 && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
 && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
 && echo "root:$PASSWD" | chpasswd \

# 清理安装包
 && rm -rf /var/lib/apt/lists/*

# 容器需要开放SSH 22端口
EXPOSE 22

# 执行supervisord来同时执行多个命令，使用 supervisord 的可执行路径启动服务。
CMD ["/usr/sbin/sshd", "-D"]