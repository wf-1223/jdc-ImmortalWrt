#!/bin/bash
# ========= Git网络优化，防止clone超时 =========
git config --global http.version HTTP/1.1
git config --global http.postBuffer 1048576000

# ========= 替换源码下载源为北大镜像，根治Failed to fetch =========
sed -i 's#https://downloads.immortalwrt.org#https://mirrors.pku.edu.cn/immortalwrt#g' repositories.conf

# ========= 【京东云一代RE-SP-01B 加载设备适配补丁】 =========
# 使用 yjzzjy4 适配仓库，ghproxy加速下载
git clone https://mirror.ghproxy.com/https://github.com/yjzzjy4/JDCloud-RE-SP-01B.git jdcloud-patch
cp -rf jdcloud-patch/target/linux/ramips/* target/linux/ramips/
cp -rf jdcloud-patch/package/* package/
rm -rf jdcloud-patch

# ========= 拉取第三方插件（ghproxy加速，避免拉取失败） =========
# Argon主题
git clone https://mirror.ghproxy.com/https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
# ZeroTier图形面板（源码自带可以不用，这里备用）
# git clone https://mirror.ghproxy.com/https://github.com/lisaac/luci-app-zerotier.git package/luci-app-zerotier

# ========= 复制files目录（uci-defaults开机脚本嵌入固件） =========
cp -rf files/* ./

# ========= Feeds更新 =========
./scripts/feeds update -a
./scripts/feeds install -a
