@echo off
cd %~dp0
set IMAGE_NAME=%1
if "%~1" == "" set /p IMAGE_NAME=imagename:
echo IMAGE_NAME:%IMAGE_NAME%
echo Path:%CD%
echo remove temp images
docker stop %IMAGE_NAME%
docker rm %IMAGE_NAME%
docker rmi %IMAGE_NAME%
docker build --no-cache -t %IMAGE_NAME%:latest -f DockerFile_run .
docker run -it --name=%IMAGE_NAME% -p 5173:5173 -v %CD%:/app  %IMAGE_NAME%:latest 