远程桌面 CredSSP加密Oracle修正
==========================

Win10远程桌面 出现 身份验证错误，要求的函数不受支持，这可能是由于CredSSP加密Oracle修正 解决方法
升级至win10 最新版本10.0.17134，远程桌面连接Window Server时报错信息如下：

```
cat >> ./source/conf.py <<'EOF'

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
}
EOF
``
