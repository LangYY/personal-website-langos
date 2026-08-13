# LANG OS · 个人网站

郎懿滢的个人网站，以「一个人的操作系统」为隐喻：三个磁盘（影像 / 网页 / 移动端）装作品，
一处网络邻居通往别处，部分工具可点开直接试用。单文件、无框架、自写窗口系统。

- **线上**：https://langos.buzzegg.cn
- **源码**：`site/index.html`（自包含单文件 HTML/CSS/JS）

## 结构
```
site/index.html              站点本体（单文件）
deploy/nginx-langos.conf     ECS nginx 配置
.github/workflows/deploy.yml  push 到 main 自动部署到 ECS
DEPLOY.md                    部署与更新手册
```

## 本地预览
直接用浏览器打开 `site/index.html` 即可，无需构建、无需服务器。

## 部署
见 [DEPLOY.md](./DEPLOY.md)。设置完成后，push 到 `main` 即自动上线。

## 待接入
`site/index.html` 顶部 `ITEMS` / `NEIGH` 数据区留了字段：填入工具线上地址与社交主页即可，
无需改动页面结构。
