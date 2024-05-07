@echo off
cd %~dp0
docker rmi $(docker images -f "dangling=true"-q)