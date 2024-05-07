# 使用指南

## 调试

创建镜像

`docker build --no-cache -t runner:latest -f DockerFile_run .`

创建容器

`docker run -it --name=runner -p 5173:5173 -v ./:/app runner:latest`

执行调试

`docker start -i runner`

更新文件后在控制台按`r`重载

## 打包

执行 buildTarget.bat
