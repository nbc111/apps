# 自动部署设置指南

## 概述
本项目已配置GitHub Actions自动部署功能。当您推送代码到master或main分支时，系统会自动构建并部署到您的服务器。

## 设置步骤

### 1. 配置GitHub Secrets
在您的GitHub仓库中，进入 Settings > Secrets and variables > Actions，添加以下secrets：

- `SERVER_HOST`: 您的服务器IP地址 (例如: 206.238.197.207)
- `SERVER_USERNAME`: SSH用户名 (例如: root)
- `SERVER_PASSWORD`: SSH密码
- `SERVER_PORT`: SSH端口 (通常是22)

### 2. 确保服务器环境
确保您的服务器上已安装：
- Node.js 18+
- Yarn
- PM2
- Git

### 3. 部署流程
1. 本地修改代码
2. 提交并推送到GitHub
3. GitHub Actions自动触发构建
4. 构建完成后自动部署到服务器
5. 服务器自动重启应用

### 4. 手动触发部署
如果需要手动触发部署，可以：
1. 进入GitHub仓库的Actions页面
2. 选择"Deploy to Server"工作流
3. 点击"Run workflow"按钮

### 5. 查看部署状态
- 在GitHub仓库的Actions页面查看部署进度
- 部署完成后，访问 http://206.238.197.207:1311 查看更新

## 注意事项
- 确保服务器防火墙允许SSH连接
- 确保GitHub Actions有足够的权限访问您的仓库
- 部署过程中服务器应用会短暂重启，请合理安排部署时间 