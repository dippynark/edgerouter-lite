# Consul

```sh
go get -d github.com/hashicorp/consul
cd github.com/hashicorp/consul
git checkout v1.5.2
export GOOS=linux                                                               export GOARCH=mips64
unset GOBIN
# https://github.com/boltdb/bolt/issues/656
# https://www.linux-mips.org/wiki/Alignment#Unaligned_loads_and_stores_on_MIPS
cat <<EOF > ./vendor/github.com/boltdb/bolt/bolt_mips64.go
// +build mips64
package bolt

// maxMapSize represents the largest mmap size supported by Bolt.
const maxMapSize = 0xFFFFFFFFFFFF // 256TB

// maxAllocSize is the size used when creating array pointers.
const maxAllocSize = 0x7FFFFFFF

// Are unaligned load/stores broken on this arch?
var brokenUnaligned = false

EOF
make -f GNUmakefile dev-build
# ./pkg/bin/linux_mips64/consul
```