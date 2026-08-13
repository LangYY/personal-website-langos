# 交接说明 · 给接手的 Claude Code

你好，接手的 cc。这是郎懿滢（GitHub: **LangYY**，邮箱 lang.soda@gmail.com）的个人网站项目。
前一个云端会话把网站和部署配置都做好了，但受限于「App 身份 token 不能建仓、也连不进本地/ECS」，
做不了最后的建仓、推送、部署三步。你以本人身份在本地跑，正好补上。**请先读完这份，再动手。**

---

## 0. 一句话目标
把这个单文件网站推到 GitHub 仓库 `personal-website-langos`（public），
并部署到用户的阿里云 **ECS**，域名 **langos.buzzegg.cn**，之后 push 即自动上线。

---

## 1. 这是什么：LANG OS
个人网站，不是简历、不是普通作品集，而是一台**以「操作系统」为隐喻的个人乐园**。
用户的核心事实是「一个人 = 一整间公司」，所以网站做成她的**桌面**：

- 视觉：**纸墨 OS**——墨色桌面 + 宣纸窗口 + 朱砂印章图标 + 宋体/等宽字，鼠标划过留淡青墨迹。
- 结构（用户亲定的四板块，已落地为桌面上的「位置」）：
  - **三个磁盘**：`影像:/`（视频作品）、`网页:/`（可点开试用的 Web 工具）、`移动端:/`（小程序/App，扫码）
  - **一处网络邻居**：社交外链（小红书 / X / GitHub）
  - 外加系统工具：**关于本机、进程管理器、终端**（终端有 `help`/`ls`/`open`/`sudo hire` 彩蛋）
- 交互：窗口可拖拽、可最小化到 dock；双击磁盘进文件夹视图，再点单件展开；有开机动画。
- 技术：**单文件、零依赖、原生 JS**，全部在 `site/index.html` 里。别引框架、别拆文件——单文件是刻意的。

> 设计基调是「先锋但克制」，是用户台账/务实气质的操作系统化，不要往赛博霓虹模板上带。

---

## 2. 关于用户（内容要准，别编）
以下是对话中已确认的事实，供你核对文案，**不确定的一律问用户，不要杜撰**：
- 经营内容制作公司 **Buzzegg** 约五年（2019–2024），从注册到交付全链路一人打通。
- 代表作 **《熊猫团团看世界》**：受邀为**优酷少儿频道**做的 **10 集 AI 动画**，一个人全流程，约 30 天、直接成本 <¥3,000。
- **HTML 预览微信小程序**：独立开发，2026.07 上线，正在小红书冷启动。
- 自造工具：**精听室**（英语精听，自用中）、**Focus Tree**（注意力任务树，可用未上线）、**AI 视频生产工作流**（本地部署 Wan 2.2 等）。有一个「AI 动画流程 Skill」半途而废（诚实标注为「已崩溃」）。
- 商业影像客户：**NIO / 腾讯 / 微软 Xbox / 雷蛇**。
- 背景：生物信息学，同济学士、曼彻斯特硕士；目前在一家医疗公司把停滞的 AI 项目推回验收。
- 语气偏好：诚实、带点自嘲（例：「有做爆款的手感，没有当博主的恒心——所以我造工具，不做网红」）。不要做成「求职材料」，求职意图只藏在终端 `sudo hire` 彩蛋里。

---

## 3. 仓库现状（本包内容）
```
site/index.html               网站本体（单文件，即 LANG OS）
.github/workflows/deploy.yml  push 到 main 自动 rsync 到 ECS
deploy/nginx-langos.conf      langos.buzzegg.cn 的 nginx 配置
DEPLOY.md                     完整部署手册（DNS/备案/nginx/certbot/secrets）
README.md                     仓库说明
push.sh                       一键 gh 建仓+推送脚本（bash）
.gitignore                    忽略私钥
HANDOFF.md                    本文件（推仓时可留可删）
```

---

## 4. 你要做的三步

### 第一步：建仓 + 推送（你以 LangYY 身份，能建仓）
```bash
gh auth status                 # 确认已登录为 LangYY，没有就 gh auth login
git init && git branch -M main
git add . && git commit -m "LANG OS personal website"
gh repo create personal-website-langos --public --source=. --remote=origin --push
```

### 第二步：部署到 ECS（按 DEPLOY.md）
- 用户在阿里云控制台做（你指导 + 生成命令）：DNS 加 `langos` A 记录指向 ECS IP；确认 `buzzegg.cn` 已备案（子域名一般沿用主备案）。
- ECS 上：装 nginx、建 `/var/www/langos`、放 `deploy/nginx-langos.conf`、`certbot` 上 HTTPS。
- GitHub 仓库配 4 个 Secret（`ECS_HOST/ECS_USER/ECS_SSH_KEY/ECS_PORT`），此后 push 自动部署。
- **想最快看到网站亮起来**：跳过 Actions，直接 `rsync -avz site/ 用户@ECS:/var/www/langos/`，配好 nginx+DNS 即可访问。

### 第三步：填内容（用户在陆续给素材，边给边填）
在 `site/index.html` 顶部的**数据区**填字段，不用改结构：
- `NEIGH` 数组 → 三个社交 `href`：小红书主页、X 主页、GitHub（`https://github.com/LangYY` 已确认）。
- `ITEMS.dictation.url` / `ITEMS.focustree.url` → 工具线上地址；**一填，窗口内 iframe 直接可试用**。
- 素材位（搜 `media-slot` / `qr-slot`）→ 熊猫团团视频或剧照、Buzzegg showreel、小程序码、闲笔照片。
  视频建议走 B站/YouTube 嵌入或 ECS/OSS，别塞进仓库。

---

## 5. 待办清单（勾掉即进度）
- [ ] gh 登录为 LangYY
- [ ] 建仓 personal-website-langos + 首次推送
- [ ] DNS: langos.buzzegg.cn → ECS IP
- [ ] 确认 buzzegg.cn 备案覆盖子域名
- [ ] ECS: nginx + /var/www/langos + 配置生效
- [ ] HTTPS (certbot)
- [ ] GitHub Actions 4 个 Secret，验证自动部署
- [ ] 填社交链接（小红书 / X）
- [ ] 填工具线上地址（精听室 / Focus Tree）
- [ ] 接入素材（熊猫团团 / showreel / 小程序码 / 闲笔）

## 6. 已知坑
- 单文件是刻意设计，别拆、别上框架。
- 工具 iframe 上线前注意：若应用烧的是用户自己的 API key，公开前要加访客限额/自带 key；且需允许被 iframe 嵌入（`frame-ancestors` / 去掉 `X-Frame-Options: DENY`），否则窗口内嵌不进，会退化成「新标签打开」。
- ECS 在中国大陆 → 域名必须已备案，这是硬门槛。
