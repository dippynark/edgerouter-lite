# Vault

```sh
cd ~/src
git clone https://github.com/hashicorp/vault
git checkout v1.1.3
make boostrap
# export GOOS=linux
# export GOARCH=mips64
# make dev
gox -osarch=linux/mips64 -gcflags '' -ldflags '-X github.com/hashicorp/vault/sdk/version.GitCommit='\''ad48875fd4afa25d5acece94eae9ae2152a2f6b6+CHANGES'\''' -output 'pkg/{{.OS}}_{{.Arch}}/vault' -tags=vault .
pkg/linux_mips64/vault # zsh: exec format error: pkg/linux_mips64/vault
```