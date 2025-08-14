# Polkadot 应用部署指南

## 🎯 部署目标
将 Polkadot 应用部署到服务器 `206.238.197.207`，通过域名 `https://www.nbexplorer.cc` 访问。

## 📋 前置要求

### 本地环境
- ✅ Node.js >= 18.14
- ✅ Yarn 4.6.0+
- ✅ 项目已成功构建

### 服务器环境
- ✅ Ubuntu/CentOS 服务器
- ✅ 开放端口：80, 443, 22
- ✅ 域名DNS已指向服务器IP

## 🚀 部署步骤

### 第一步：本地构建
```bash
# 在项目根目录执行
yarn build:www
```

### 第二步：创建部署包
```bash
# 运行部署脚本
.\deploy.ps1
```

### 第三步：上传到服务器
将生成的 `nbexplorer-deploy.zip` 文件上传到服务器的 `/tmp/` 目录。

**方法1：使用SCP（推荐）**
```bash
scp nbexplorer-deploy.zip root@206.238.197.207:/tmp/
```

**方法2：使用SFTP客户端**
- 主机：206.238.197.207
- 用户名：root
- 密码：Tk%Cv7AgMwpIv&Z
- 端口：22

### 第四步：服务器端部署

#### 4.1 连接到服务器
```bash
ssh root@206.238.197.207
```

#### 4.2 运行部署脚本
```bash
# 上传脚本到服务器
scp server-deploy.sh root@206.238.197.207:/tmp/

# 在服务器上执行
chmod +x /tmp/server-deploy.sh
bash /tmp/server-deploy.sh
```

#### 4.3 手动部署（如果脚本失败）
```bash
# 更新系统
apt update && apt upgrade -y

# 安装必要软件
apt install -y nginx unzip

# 创建网站目录
mkdir -p /var/www/nbexplorer

# 解压部署文件
cd /tmp
unzip nbexplorer-deploy.zip -d /var/www/nbexplorer/

# 设置权限
chown -R www-data:www-data /var/www/nbexplorer
chmod -R 755 /var/www/nbexplorer

# 配置Nginx
cat > /etc/nginx/sites-available/nbexplorer << 'EOF'
server {
    listen 80;
    server_name www.nbexplorer.cc nbexplorer.cc;
    
    root /var/www/nbexplorer;
    index index.html;
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    error_page 404 /index.html;
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/nbexplorer /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试配置
nginx -t

# 重启Nginx
systemctl restart nginx
systemctl enable nginx
```

### 第五步：配置SSL证书

#### 5.1 安装Certbot
```bash
apt install -y certbot python3-certbot-nginx
```

#### 5.2 获取SSL证书
```bash
certbot --nginx -d www.nbexplorer.cc -d nbexplorer.cc
```

#### 5.3 自动续期
```bash
# 测试自动续期
certbot renew --dry-run

# 添加到crontab
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -
```

## 🔧 配置说明

### Nginx配置特点
- **静态文件缓存**：JS、CSS等文件缓存1年
- **SPA支持**：所有路由都返回index.html
- **安全头**：XSS保护、内容类型检查等
- **错误处理**：404错误返回index.html

### 多项目支持
配置文件已预留其他项目的配置位置，只需：
1. 复制server块
2. 修改server_name和root路径
3. 重新加载Nginx配置

## 📊 监控和维护

### 查看服务状态
```bash
systemctl status nginx
nginx -t
```

### 查看日志
```bash
# Nginx访问日志
tail -f /var/log/nginx/access.log

# Nginx错误日志
tail -f /var/log/nginx/error.log

# 系统日志
journalctl -u nginx
```

### 性能优化
```bash
# 启用gzip压缩
# 在nginx.conf中添加：
gzip on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
```

## 🚨 故障排除

### 常见问题

#### 1. 网站无法访问
```bash
# 检查Nginx状态
systemctl status nginx

# 检查端口监听
netstat -tlnp | grep :80
netstat -tlnp | grep :443

# 检查防火墙
ufw status
```

#### 2. SSL证书问题
```bash
# 检查证书状态
certbot certificates

# 重新获取证书
certbot --nginx -d www.nbexplorer.cc -d nbexplorer.cc --force-renewal
```

#### 3. 权限问题
```bash
# 重新设置权限
chown -R www-data:www-data /var/www/nbexplorer
chmod -R 755 /var/www/nbexplorer
```

## 📞 技术支持

如果遇到问题，请检查：
1. 服务器防火墙设置
2. 域名DNS解析
3. Nginx配置文件语法
4. 文件权限设置
5. SSL证书有效期

## 🔄 更新部署

### 重新部署
```bash
# 本地重新构建
yarn build:www

# 重新打包
.\deploy.ps1

# 上传新包到服务器
scp nbexplorer-deploy.zip root@206.238.197.207:/tmp/

# 在服务器上更新
cd /tmp
unzip -o nbexplorer-deploy.zip -d /var/www/nbexplorer/
chown -R www-data:www-data /var/www/nbexplorer
systemctl reload nginx
```

---

**部署完成后，您的应用将通过 https://www.nbexplorer.cc 访问！** 🎉
