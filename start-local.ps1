# NBCoin Portal 本地开发服务器启动脚本
Write-Host "启动NBCoin Portal本地开发服务器..." -ForegroundColor Green
Write-Host "端口: 1311" -ForegroundColor Yellow
Write-Host "访问地址: http://localhost:1311" -ForegroundColor Yellow
Write-Host ""

# 切换到脚本所在目录
Set-Location $PSScriptRoot

# 启动开发服务器
yarn start

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
