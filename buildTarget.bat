@echo off
cd %~dp0
set IMAGE_NAME=%1
if "%~1" == "" set /p IMAGE_NAME=imagename:
echo IMAGE_NAME:%IMAGE_NAME%
docker build --no-cache -t %IMAGE_NAME%:latest -f DockerFile_build .
docker run --name=%IMAGE_NAME% %IMAGE_NAME%:latest
docker cp %IMAGE_NAME%:/app/minunit/.vitepress/dist ./dist
echo remove temp images
docker stop %IMAGE_NAME%
docker rm %IMAGE_NAME%
docker rmi %IMAGE_NAME%