# NBCoin Portal 本地开发配置

## 端口配置

本地开发服务器使用端口 **1311**，避免与常用端口（3000、8080等）冲突。

## 启动方式

### 方式1: 使用yarn命令
```bash
yarn start
```

### 方式2: 使用Windows批处理文件
双击运行 `start-local.bat`

### 方式3: 使用PowerShell脚本
```powershell
.\start-local.ps1
```

## 访问地址

- 本地访问: http://localhost:1311
- 局域网访问: http://[你的IP]:1311

## 配置文件

- `packages/apps/webpack.serve.cjs` - 开发服务器配置
- `package.json` - 启动脚本配置

## 端口修改

如需修改端口，请同时更新以下文件：

1. `packages/apps/webpack.serve.cjs` 中的 `port` 配置
2. `package.json` 中的 `start` 脚本
3. 本文档中的端口说明

## 注意事项

- 确保1311端口未被其他应用占用
- 开发服务器支持热重载
- 支持局域网访问，方便移动设备测试
