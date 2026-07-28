#!/bin/bash
set -e

# Git网络优化，防止clone超时
git config --global http.version HTTP/1.1
git config --global http.postBuffer 1048576000
git config --global core.compression 0

# 替换下载源为北大镜像，解决Failed to fetch
sed -i 's#https://downloads.immortalwrt.org#https://mirrors.pku.edu.cn/immortalwrt#g' repositories.conf

# 加载京东云一代 RE-SP-01B 适配补丁
git clone https://github.com/yjzzjy4/JDCloud-RE-SP-01B.git jdcloud-patch
cp -rf jdcloud-patch/target/linux/ramips/* target/linux/ramips/
cp -rf jdcloud-patch/package/* package/
rm -rf jdcloud-patch

# 拉取Argon主题
rm -rf package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# 复制自定义配置文件
cp -rf files/* ./

# 更新软件包feeds
./scripts/feeds update -a
./scripts/feeds install -a
