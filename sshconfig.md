# SSH config for Gitlab

> https://docs.github.com/pt/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

> Generate SSH key pair

```bash
ssh-keygen -t rsa -b 4096
```

> Activate ssh agent

```bash
eval `ssh-agent -s`
```

> Add the private key to SSH agent

```bash
ssh-add ~/.ssh/id_rsa
```

> Copy the content from your public key and add on your Gitlab profile here:
- https://gitlab.com/-/profile/keys

```bash
cat ~/.ssh/id_rsa.pub
```

> Add Gitlab config to ~/.ssh/config

```
cat >> ~/.ssh/config <<EOF
# GitLab.com
Host gitlab.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa
EOF
```

> Test Gitlab connection

```bash
ssh -T git@gitlab.com
```
