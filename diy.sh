#!/bin/bash
set -e

# =========新增：京东云RE-SP-01B 32MB Flash容量解除限制=========
sed -i 's/IMAGE_SIZE := 16384k/IMAGE_SIZE := 32768k/' target/linux/ramips/image/mt7621.mk

# Git网络优化
git config --global http.version HTTP/1.1
git config --global http.postBuffer 1048576000
git config --global core.compression 0

# 加载京东云一代 RE-SP-01B 适配补丁
git clone https://github.com/yjzzjy4/JDCloud-RE-SP-01B.git jdcloud-patch
echo "===== Patch Directory List ====="
ls -la jdcloud-patch/

if [ -d "jdcloud-patch/target" ];then
  cp -rf jdcloud-patch/target/* target/
fi
if [ -d "jdcloud-patch/package" ];then
  cp -rf jdcloud-patch/package/* package/
fi

rm -rf jdcloud-patch

# 拉取Argon主题
rm -rf package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# 复制自定义配置文件
cp -rf ../files/* ./

# 更新软件包feeds
./scripts/feeds update -a
./scripts/feeds install -a
