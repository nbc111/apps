# NBCoin Explorer 远程部署指南

## 📋 部署概览

- **目标服务器**: 206.238.197.207
- **部署目录**: /opt/polkadot-apps
- **应用端口**: 1311
- **Nginx HTTP端口**: 8080 (避免与Docker冲突)
- **Nginx HTTPS端口**: 8443 (避免与Docker冲突)
- **域名**: https://www.nbexplorer.cc:8443/
- **反向代理**: Nginx

## 🚀 快速部署

### 方式1: 使用PowerShell脚本 (推荐Windows用户)

```powershell
# 在PowerShell中运行
.\deploy-remote.ps1

# 或者指定自定义参数
.\deploy-remote.ps1 -RemoteHost "your-server-ip" -RemoteUser "your-username"
```

### 方式2: 使用批处理文件

```cmd
# 双击运行
deploy-remote.bat
```

### 方式3: 使用Bash脚本 (需要Git Bash或WSL)

```bash
# 在Git Bash或WSL中运行
bash deploy-remote.sh
```

## 📁 文件结构

```
nginx/
├── nbexplorer.conf          # Nginx配置文件 (8080/8443端口)
├── deploy-remote.sh         # Bash部署脚本
├── deploy-remote.bat        # Windows批处理部署脚本
├── deploy-remote.ps1        # PowerShell部署脚本
└── DEPLOYMENT_README.md     # 部署说明文档
```

## ⚙️ 部署前准备

### 1. 服务器要求

- **操作系统**: Ubuntu 18.04+ / CentOS 7+
- **Node.js**: v18.14+
- **Yarn**: v4.6.0+
- **PM2**: v6.0+
- **Nginx**: v1.18+
- **Git**: v2.34+

### 2. 本地要求

- **PowerShell 5.0+** 或 **Git Bash** 或 **WSL**
- **SSH客户端** (Windows 10+ 内置)
- **SCP支持** (文件传输)

### 3. 网络要求

- 服务器可以访问GitHub
- 本地可以SSH连接到服务器
- 服务器8080/8443端口可用

## 🔧 手动部署步骤

如果自动脚本失败，可以按照以下步骤手动部署：

### 步骤1: 连接到服务器
```bash
ssh root@206.238.197.207
```

### 步骤2: 清理环境
```bash
# 停止进程
pm2 stop all
pm2 delete all
pkill -f "webpack"
systemctl stop nginx

# 清理目录
rm -rf /opt/polkadot-apps
```

### 步骤3: 部署应用
```bash
# 创建目录
mkdir -p /opt/polkadot-apps
cd /opt/polkadot-apps

# 克隆代码
git clone https://github.com/polkadot-js/apps.git .

# 修改端口
sed -i 's/port: 3000/port: 1311/g' packages/apps/webpack.serve.cjs
sed -i 's/--port 3000/--port 1311/g' package.json

# 安装依赖
yarn install

# 构建项目
yarn build
```

### 步骤4: 配置Nginx
```bash
# 上传配置文件 (在本地执行)
scp nginx/nbexplorer.conf root@206.238.197.207:/etc/nginx/sites-available/nbexplorer

# 在服务器上执行
ln -sf /etc/nginx/sites-available/nbexplorer /etc/nginx/sites-enabled/
nginx -t
systemctl start nginx
systemctl enable nginx
```

### 步骤5: 启动应用
```bash
cd /opt/polkadot-apps
pm2 start "yarn start" --name "nbc-apps"
pm2 save
pm2 startup
```

## ✅ 部署后检查

### 1. 检查应用状态
```bash
pm2 status
```

### 2. 检查端口监听
```bash
netstat -tlnp | grep :1311
```

### 3. 检查Nginx状态
```bash
systemctl status nginx
```

### 4. 检查域名访问
```bash
curl -I https://www.nbexplorer.cc:8443/
```

## 🌐 访问地址

### 生产环境访问：
- **HTTPS**: https://www.nbexplorer.cc:8443/
- **HTTP**: http://www.nbexplorer.cc:8080/ (自动跳转到HTTPS)

### 本地开发环境：
- **HTTP**: http://localhost:1311/

## 🔍 端口配置说明

### 为什么使用8080/8443端口？

1. **避免与Docker容器冲突**
   - 80端口被Docker容器占用
   - 443端口被Docker容器占用

2. **支持多工程部署**
   - 工程1: 8080/8443 + 1311
   - 工程2: 8081/8444 + 1312
   - 工程3: 8082/8445 + 1313

3. **架构清晰**
   - Nginx: 8080/8443 (反向代理)
   - 应用: 1311 (业务逻辑)

## 🐛 常见问题

### 问题1: SSH连接失败
**解决方案**: 检查网络连接、SSH配置、防火墙设置

### 问题2: 端口被占用
**解决方案**: 检查端口占用情况，停止冲突服务
```bash
netstat -tlnp | grep :1311
lsof -i :1311
```

### 问题3: Nginx启动失败
**解决方案**: 检查配置文件语法，查看错误日志
```bash
nginx -t
journalctl -u nginx -f
```

### 问题4: 应用启动失败
**解决方案**: 检查依赖安装、构建状态、端口配置
```bash
yarn install
yarn build
pm2 logs nbc-apps
```

## 📞 技术支持

如果遇到部署问题，请提供以下信息：

1. **错误日志**: PM2日志、Nginx日志
2. **系统信息**: 操作系统版本、Node.js版本
3. **网络状态**: 端口占用情况、防火墙配置
4. **具体错误**: 错误信息和发生步骤

## 🔄 更新部署

### 方式1: 重新运行部署脚本
```bash
.\deploy-remote.ps1
```

### 方式2: 手动更新
```bash
# 在服务器上执行
cd /opt/polkadot-apps
git pull origin master
yarn install
yarn build
pm2 restart nbc-apps
```

## 📝 注意事项

1. **备份配置**: 部署前备份重要的配置文件
2. **测试环境**: 建议先在测试环境验证部署流程
3. **监控日志**: 部署后持续监控应用和Nginx日志
4. **安全配置**: 确保SSL证书有效，防火墙配置正确
5. **性能优化**: 根据服务器配置调整Nginx和Node.js参数
6. **端口管理**: 8080/8443端口用于Nginx，1311端口用于应用

---

**祝您部署顺利！** 🎉
