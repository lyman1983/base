# base
支持ssh和基本工具的基础镜像

## 使用
启动容器
> docker run --name t1 -d -p 7002:22 registry.cn-hangzhou.aliyuncs.com/lyman2016/base
ssh登陆容器，提供默认的账户密码，进入容器后自行修改
> 默认账户/密码 root/passwd