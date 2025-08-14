# 部署脚本 - 将Polkadot应用部署到远程服务器
# 使用方法: .\deploy.ps1

param(
    [string]$ServerIP = "206.238.197.207",
    [string]$Username = "root",
    [string]$Password = "Tk%Cv7AgMwpIv&Z",
    [string]$Domain = "www.nbexplorer.cc"
)

Write-Host "🚀 开始部署 Polkadot 应用到服务器..." -ForegroundColor Green

# 检查构建文件是否存在
$BuildPath = "packages\apps\build"
if (-not (Test-Path $BuildPath)) {
    Write-Host "❌ 构建目录不存在，请先运行 yarn build:www" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 构建文件检查完成" -ForegroundColor Green

# 创建临时部署目录
$TempDir = "deploy-temp"
if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir -Force

# 复制构建文件到临时目录
Write-Host "📁 准备部署文件..." -ForegroundColor Yellow
Copy-Item "$BuildPath\*" $TempDir -Recurse -Force

# 创建部署包
$DeployPackage = "nbexplorer-deploy.zip"
if (Test-Path $DeployPackage) {
    Remove-Item $DeployPackage -Force
}

# 压缩部署文件
Write-Host "📦 创建部署包..." -ForegroundColor Yellow
Compress-Archive -Path "$TempDir\*" -DestinationPath $DeployPackage

# 清理临时文件
Write-Host "🧹 清理临时文件..." -ForegroundColor Yellow
Remove-Item $TempDir -Recurse -Force

Write-Host "✅ 本地部署准备完成！" -ForegroundColor Green
Write-Host ""
Write-Host "📋 下一步操作：" -ForegroundColor Cyan
Write-Host "1. 将 $DeployPackage 上传到服务器 /tmp/ 目录" -ForegroundColor White
Write-Host "2. 在服务器上执行以下命令：" -ForegroundColor White
Write-Host "   ssh root@$ServerIP" -ForegroundColor White
Write-Host "   cd /tmp" -ForegroundColor White
Write-Host "   unzip nbexplorer-deploy.zip -d /var/www/nbexplorer/" -ForegroundColor White
Write-Host "   chown -R www-data:www-data /var/www/nbexplorer" -ForegroundColor White
Write-Host "   chmod -R 755 /var/www/nbexplorer" -ForegroundColor White
Write-Host "3. 配置Nginx和SSL证书" -ForegroundColor White
Write-Host "4. 重启Nginx服务" -ForegroundColor White
