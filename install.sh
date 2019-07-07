#!/bin/bash

# 优化ssh连接速度
sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
sed -i "s/GSSAPIAuthentication .*/GSSAPIAuthentication no/" /etc/ssh/sshd_config
systemctl restart sshd

# 关闭防火墙,selinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 可打开文件限制 进程限制
if [ ! "$(cat /etc/security/limits.conf | grep '# mango')" ]; then
    echo -e "\n# mango" >> /etc/security/limits.conf
    echo "* soft nofile 65535" >> /etc/security/limits.conf
    echo "* hard nofile 65535" >> /etc/security/limits.conf
    echo "* soft nproc 65535"  >> /etc/security/limits.conf
    echo "* hard nproc 65535"  >> /etc/security/limits.conf
    echo "* soft  memlock  unlimited"  >> /etc/security/limits.conf
    echo "* hard memlock  unlimited"  >> /etc/security/limits.conf
fi

# 安装yum源
rm -f /etc/yum.repos.d/*.repo
curl -so /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo
curl -so /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i '/aliyuncs.com/d' /etc/yum.repos.d/Centos-7.repo /etc/yum.repos.d/epel-7.repo

# 时间同步
yum install -y ntpdate
ntpdate ntp1.aliyun.com
hwclock -w
crontab -l > /tmp/crontab.tmp
echo "*/20 * * * * /usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1 && /usr/sbin/hwclock -w" >> /tmp/crontab.tmp
cat /tmp/crontab.tmp | uniq > /tmp/crontab
crontab /tmp/crontab
rm -f /tmp/crontab.tmp /tmp/crontab

# 安装 git
yum install -y git

# 安装 Python3.6
yum -y install python36 python36-devel

# 配置并载入 Python3 虚拟环境
cd /opt
python3.6 -m venv py3         # py3 为虚拟环境名称, 可自定义
source /opt/py3/bin/activate 

# 配置pip源
mkdir -p /root/.pip
cat >  /root/.pip/pip.conf   <<EOF
[global]
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com
EOF

# 安装配置sphinx
pip install sphinx
mkdir -p /home/readdocs/docs && cd $_

# 创建自动初始化脚本
yum install -y expect
cat > sphinx-init.exp  <<'EOF'
#!/usr/bin/expect
set timeout 10

spawn bash -c "sphinx-quickstart"
expect "Separate source and build directories* "
    send "y\n"
expect "Project name: "
    send "mydocs\n"
expect "Author name(s): "
    send "nanonymity\n"
expect "Project release* "
    send "0.1\n"
expect "Project language* "
    send "zh_CN\n"
expect eof
EOF

# 初始化
expect sphinx-init.exp

# 安装markdown插件
pip install recommonmark
sed -i "/^extensions/a\ 'recommonmark'" ./source/conf.py

# 安装更改主题
pip install sphinx_rtd_theme
sed -i 's#alabaster#sphinx_rtd_theme#' ./source/conf.py

# 去哪找markdown插件
pip install mkdocs

# 配置
cat > readthedocs.yml <<'EOF'
# .readthedocs.yml
# Read the Docs configuration file
# See https://docs.readthedocs.io/en/stable/config-file/v2.html for details

# Required
version: 2

# Build documentation in the docs/ directory with Sphinx
sphinx:
  configuration: source/conf.py

# Build documentation with MkDocs
#mkdocs:
#  configuration: mkdocs.yml

# Optionally build your docs in additional formats such as PDF and ePub
formats: all

# Optionally set the version of Python and requirements required to build your docs
python:
  version: 3.6
  install:
    - requirements: requirements.txt
EOF

# 导出依赖关系
pip freeze > requirements.txt


cat >> ./source/conf.py <<'EOF'

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
}
EOF

# 生成静态文件
make html
