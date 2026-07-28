#!/bin/bash
set -e

# Git网络优化
git config --global http.version HTTP/1.1
git config --global http.postBuffer 1048576000
git config --global core.compression 0

# 加载京东云一代 RE-SP-01B 适配补丁
git clone https://github.com/yjzzjy4/JDCloud-RE-SP-01B.git jdcloud-patch
echo "===== 查看补丁仓库目录 ====="
ls -la jdcloud-patch/

# 【重点】先看日志输出，确认里面文件夹名称！
# 如果补丁仓库内直接是 target/ 就保留；
# 如果里面是 openwrt/target/ 后续我再调整
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
cp -rf files/* ./

# 更新软件包feeds
./scripts/feeds update -a

# 替换软件源
sed -i 's#https://downloads.immortalwrt.org#https://mirrors.pku.edu.cn/immortalwrt#g' feeds/distfeeds.conf

./scripts/feeds install -a
