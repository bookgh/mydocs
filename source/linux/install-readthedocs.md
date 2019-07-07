Read Teh Docs Install
========================

    系统: CentOS-7.6-1810 最小化安装

系统优化

```sh
# 优化ssh连接速度
sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
sed -i "s/GSSAPIAuthentication .*/GSSAPIAuthentication no/" /etc/ssh/sshd_config
systemctl restart sshd

# selinux
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
```

安装python-36

```sh
yum -y install python36 python36-devel
```

配置并载入 Python3 虚拟环境

```sh
cd /opt
python3.6 -m venv py3
source /opt/py3/bin/activate
```

配置pip源

```sh
mkdir -p /root/.pip
cat >  /root/.pip/pip.conf   <<EOF
[global]
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com
EOF
```

安装/初始化 sphinx

```sh
# 安装 sphinx
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
```

安装/配置 markdown 插件

```sh
pip install recommonmark

sed -i "/^extensions/a\ 'recommonmark'" ./source/conf.py
cat >> ./source/conf.py <<'EOF'

import recommonmark
from recommonmark.transform import AutoStructify

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
}

github_doc_root = 'https://github.com/rtfd/recommonmark/tree/master/doc/'
def setup(app):
    app.add_config_value('recommonmark_config', {
            'url_resolver': lambda url: github_doc_root + url,
            'auto_toc_tree_section': 'Contents',
            }, True)
    app.add_transform(AutoStructify)
EOF
```

安装更改sphinx主题

```sh
pip install sphinx_rtd_theme
sed -i 's#alabaster#sphinx_rtd_theme#' ./source/conf.py
```

测试验证

```sh
make html
cd /home/readdocs/docs/build/html
/usr/bin/python -m SimpleHTTPServer 80       # 请放行80端口或关闭防火墙 打开浏览器查看
```

生成 python 依赖关系列表

```sh
pip freeze > requirements.txt
```

上传 github

```sh
# 安装 git
yum -y install git

cd /home/readdocs/docs
git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/bookgh/mydocs.git
git push -u origin master
```

