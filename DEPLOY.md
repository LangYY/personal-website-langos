# 部署手册 · langos.buzzegg.cn

站点是**单文件静态页**（`site/index.html`），部署极简：nginx 托一个目录即可。
下面分「一次性设置」和「日常更新」两部分。带 🔴 的步骤只能你在阿里云/GitHub 控制台做，我做不了。

---

## A. 一次性设置

### 1. 🔴 建仓库并授权
- 在 GitHub 新建仓库 `personal-website-langos`
- 确保 Claude 的 GitHub App 能访问它（App 设为 All repositories，或把这个新仓库加进 App 的 selected repos）
- 授权后告诉我，我把 `site/` `.github/` `deploy/` 全套推进去

### 2. 🔴 DNS 解析
在 buzzegg.cn 的 DNS 控制台加一条记录：

| 主机记录 | 类型 | 记录值 |
|---|---|---|
| `langos` | A | ECS 的公网 IP |

（若走 CDN，则改成 CNAME 指向 CDN 域名。）

### 3. 🔴 ICP 备案
- ECS 在中国大陆 → 域名必须已备案。`buzzegg.cn` 作为你的旧公司域名大概率**已备案**。
- 子域名 `langos.` 通常**沿用主域名备案**，无需重新备案，直接解析即可。
- 若 `buzzegg.cn` 尚未备案 / 已注销，需先在阿里云做备案（周期 7–20 天），这是硬门槛。

### 4. ECS 上装 nginx + 建目录（SSH 登录后执行）
```bash
sudo apt update && sudo apt install -y nginx rsync      # Debian/Ubuntu
# CentOS/Alibaba Cloud Linux: sudo yum install -y nginx rsync

sudo mkdir -p /var/www/langos
sudo chown -R "$USER":"$USER" /var/www/langos           # 让部署用户可写
```

### 5. 放 nginx 配置
把 `deploy/nginx-langos.conf` 拷到 ECS：
```bash
sudo cp deploy/nginx-langos.conf /etc/nginx/conf.d/langos.buzzegg.cn.conf
sudo nginx -t && sudo systemctl reload nginx
```

### 6. 🔴 配置 GitHub Actions 自动部署密钥
在 ECS 上给部署生成一把专用 SSH key（不要用你日常私钥）：
```bash
ssh-keygen -t ed25519 -f ~/.ssh/deploy_langos -N ""
cat ~/.ssh/deploy_langos.pub >> ~/.ssh/authorized_keys   # 公钥加入信任
cat ~/.ssh/deploy_langos                                 # 私钥全文，复制备用
```
然后在 GitHub 仓库 **Settings → Secrets and variables → Actions** 新增 4 个 secret：

| Secret 名 | 值 |
|---|---|
| `ECS_HOST` | ECS 公网 IP |
| `ECS_USER` | 登录用户名（如 `root` 或 `www`） |
| `ECS_SSH_KEY` | 上面 `deploy_langos` 私钥全文 |
| `ECS_PORT` | SSH 端口（默认 `22`） |

> 安全提示：私钥只贴进 GitHub Secret，**不要提交进仓库**。ECS 安全组放行 80/443（和你的 SSH 端口）。

### 7. HTTPS（备案+解析生效后）
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d langos.buzzegg.cn
```
certbot 自动申请证书、改写 nginx、配置自动续期。

---

## B. 日常更新（设置完成后）

以后**只要 push 到 main**，GitHub Actions 就自动把最新 `site/` 同步上线，无需登服务器。
- 我改内容（填素材、社交链接、工具地址）→ push → 约 1 分钟后 langos.buzzegg.cn 更新
- 想手动触发：仓库 Actions 页 → Deploy to ECS → Run workflow

### 首次没配 Actions 时的手动部署
在你本机（装了 rsync）：
```bash
rsync -avz --delete site/ 用户名@ECS_IP:/var/www/langos/
```

---

## 手上还缺的东西（你梳理素材时一并给我）
- 社交真实地址：小红书主页、X handle、GitHub（已确认 github.com/LangYY）
- 工具线上地址：精听室、Focus Tree —— 填进后窗口内直接可试用
- 素材：熊猫团团视频/剧照、Buzzegg showreel、小程序码、闲笔照片
