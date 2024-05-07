# 利用docker搭建前端开发环境

使用docker可以搭建出快速的没有安装依赖的开发、编译、打包环境。这样。可以项目在任意一台安装了docker的设备中运行都不需要额外安装相关依赖。

## 使用docker搭建调试环境

运行环境镜像需要在启动时关联项目文件,调试端口,安装依赖,执行运行命令

* 构建镜像
  
```DockerFile
#运行环境node
#暴露vue默认启动端口5173
#关联工作文件夹/app
#启动时执行调试脚本
FROM node:lts-alpine AS builder
WORKDIR /app 
VOLUME [ "/app" ]
ENTRYPOINT ["sh","run.sh"]
EXPOSE 5173
```

* 运行脚本
  
  这里以我的vitepress项目为例
  
```sh
 # 安装依赖 
npm add -D vitepress
# 运行
npm run docs:dev
```

* 执行操作
  
```bat
#构建镜像
docker build --no-cache -t runner:latest -f DockerFile .
#创建容器 使用前台终端交互模式启动  并将项目路径映射到容器中
docker run -it --name=runner -p 5173:5173 -v <项目路径>:/app runner:latest
```

之后需要启动时执行

`docker start -i runner`

接下来你就可以在终端中执行调试操作了
![runner]( https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/runner.png)
**使用docker进行调试时无法在保存映射的文件时自动刷新页面，因此热更新需要手动在交互控制台中按r执行。**
