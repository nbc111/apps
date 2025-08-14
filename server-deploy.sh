#!/bin/bash

# 服务器端部署脚本
# 使用方法: bash server-deploy.sh

set -e

echo "🚀 开始服务器端部署..."

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "❌ 请使用root用户运行此脚本"
    exit 1
fi

# 更新系统包
echo "📦 更新系统包..."
apt update && apt upgrade -y

# 安装必要的软件
echo "🔧 安装必要软件..."
apt install -y nginx unzip curl wget certbot python3-certbot-nginx

# 创建网站目录
echo "📁 创建网站目录..."
mkdir -p /var/www/nbexplorer
mkdir -p /var/www/other-projects

# 解压部署文件
echo "📦 解压部署文件..."
if [ -f "/tmp/nbexplorer-deploy.zip" ]; then
    unzip -o /tmp/nbexplorer-deploy.zip -d /var/www/nbexplorer/
    echo "✅ 文件解压完成"
else
    echo "⚠️  部署文件不存在，请先上传 /tmp/nbexplorer-deploy.zip"
    echo "   您可以手动创建目录结构"
fi

# 设置文件权限
echo "🔐 设置文件权限..."
chown -R www-data:www-data /var/www/nbexplorer
chmod -R 755 /var/www/nbexplorer

# 配置Nginx
echo "⚙️  配置Nginx..."
cat > /etc/nginx/sites-available/nbexplorer << 'EOF'
server {
    listen 80;
    server_name www.nbexplorer.cc nbexplorer.cc;
    
    root /var/www/nbexplorer;
    index index.html;
    
    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }
    
    # 主要路由 - 支持SPA
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 错误页面
    error_page 404 /index.html;
    error_page 500 502 503 504 /50x.html;
}
EOF

# 启用站点
echo "🔗 启用Nginx站点..."
ln -sf /etc/nginx/sites-available/nbexplorer /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
echo "🧪 测试Nginx配置..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx配置测试通过"
    
    # 重启Nginx
    echo "🔄 重启Nginx服务..."
    systemctl restart nginx
    systemctl enable nginx
    
    echo "✅ Nginx服务已启动并设置为开机自启"
else
    echo "❌ Nginx配置测试失败，请检查配置"
    exit 1
fi

# 配置防火墙
echo "🔥 配置防火墙..."
ufw allow 'Nginx Full'
ufw allow OpenSSH
ufw --force enable

echo "✅ 防火墙配置完成"

# 获取SSL证书
echo "🔒 获取SSL证书..."
if command -v certbot &> /dev/null; then
    echo "📝 请运行以下命令获取SSL证书："
    echo "   certbot --nginx -d www.nbexplorer.cc -d nbexplorer.cc"
    echo ""
    echo "⚠️  注意：确保域名DNS已指向此服务器IP"
else
    echo "❌ certbot未安装，请手动配置SSL证书"
fi

echo ""
echo "🎉 部署完成！"
echo ""
echo "📋 下一步操作："
echo "1. 确保域名 www.nbexplorer.cc 的DNS指向此服务器IP"
echo "2. 运行 certbot --nginx -d www.nbexplorer.cc -d nbexplorer.cc 获取SSL证书"
echo "3. 访问 http://www.nbexplorer.cc 测试网站"
echo ""
echo "🔧 常用命令："
echo "   systemctl status nginx    # 查看Nginx状态"
echo "   systemctl restart nginx   # 重启Nginx"
echo "   nginx -t                  # 测试Nginx配置"
echo "   journalctl -u nginx      # 查看Nginx日志"
