# SSH config for Gitlab

> Add to ~/.ssh/config

cat >> ~/.ssh/config <<EOF
# GitLab.com
Host gitlab.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa
EOF

ssh -T git@gitlab.com
