# sing-box Docker

基于 sing-box 的 VLESS 代理服务器，支持 Heroku 一键部署和 Cloudflare Tunnel。

## 功能特性

- ✅ VLESS + WebSocket 协议
- ✅ 支持 Heroku 一键部署
- ✅ 支持 Cloudflare Tunnel（Zero Trust）
- ✅ 通过环境变量配置
- ✅ 自动适配 Heroku 动态端口

## 快速部署

### Heroku 一键部署

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/briomianopc/sing-box-docker)

点击按钮后，填写以下环境变量：

| 变量名 | 说明 | 必填 | 默认值 |
|--------|------|------|--------|
| `UUID` | VLESS 认证 UUID | ✅ | - |
| `WS_PATH` | WebSocket 路径 | ❌ | `/laowang` |
| `CLOUDFLARE_TUNNEL_TOKEN` | Cloudflare Tunnel Token | ❌ | - |

### 本地部署

```bash
docker build -t sing-box .
docker run -d -p 8080:8080 \
  -e UUID="your-uuid-here" \
  -e WS_PATH="/yourpath" \
  sing-box
```

## 使用模式

### 1. 直接模式（默认）

不设置 `CLOUDFLARE_TUNNEL_TOKEN`，sing-box 直接监听端口对外提供服务。

**适用场景：**
- 支持公开端口的容器平台（如 Heroku）
- VPS 服务器

### 2. Cloudflare Tunnel 模式

设置 `CLOUDFLARE_TUNNEL_TOKEN`，通过 Cloudflare 网络访问，无需公开端口。

**适用场景：**
- 不支持公开端口的容器平台
- 需要隐藏真实 IP
- 需要 Cloudflare CDN 加速

**配置步骤：**

1. 访问 [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/)
2. 创建 Tunnel：`Networks` → `Tunnels` → `Create a tunnel`
3. 配置 Public Hostname：
   - Public Hostname: `your-domain.com`
   - Service: `http://localhost:8080`
4. 复制 Tunnel Token 填入环境变量

## 客户端配置

### v2rayN / v2rayNG

```
协议：VLESS
地址：your-app.herokuapp.com 或 your-domain.com
端口：443（Heroku/Cloudflare）或 80
UUID：你设置的 UUID
传输协议：ws
路径：你设置的 WS_PATH（默认 /laowang）
TLS：开启（Heroku/Cloudflare 会自动处理 TLS）
```

### Clash Meta 配置

```yaml
proxies:
  - name: "sing-box"
    type: vless
    server: your-app.herokuapp.com
    port: 443
    uuid: your-uuid-here
    network: ws
    tls: true
    ws-opts:
      path: /laowang
```

### 通用配置示例

```json
{
  "protocol": "vless",
  "settings": {
    "vnext": [{
      "address": "your-app.herokuapp.com",
      "port": 443,
      "users": [{
        "id": "your-uuid-here",
        "encryption": "none"
      }]
    }]
  },
  "streamSettings": {
    "network": "ws",
    "security": "tls",
    "wsSettings": {
      "path": "/laowang"
    }
  }
}
```

## 生成 UUID

```bash
# Linux/macOS
uuidgen

# 在线生成
# https://www.uuidgenerator.net/
```

## 注意事项

1. **端口说明：**
   - Heroku 会自动分配端口并设置 `PORT` 环境变量
   - Cloudflare Tunnel 模式下监听 `127.0.0.1:8080`

2. **安全建议：**
   - 请务必修改默认 UUID
   - 建议修改默认 WebSocket 路径
   - 使用 Cloudflare Tunnel 可以隐藏真实 IP

3. **Heroku 限制：**
   - 免费套餐有流量限制
   - 应用闲置 30 分钟后会休眠
   - 每月有使用时长限制

## 许可证

[MIT License](https://github.com/briomianopc/sing-box-docker/blob/main/LICENSE)
