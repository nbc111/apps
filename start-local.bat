@echo off
echo 启动NBCoin Portal本地开发服务器...
echo 端口: 1311
echo 访问地址: http://localhost:1311
echo.

cd /d "%~dp0"
yarn start

pause
