# edgerouter-lite

This repository contains my modifications to the [EdgeRouter Lite][1]:
- [dnsmasq][2] for DHCP
- [matchbox][3] for CoreOS PXE boot
- [Vault][10] for PKI

## Prerequisites

In order to use `matchbox`, you first need to generate the CA and serving key
pairs and place them in `matchbox.d/etc/matchbox`. To do this you can use the
[cert-gen][8] script in the `matchbox` repository. Read
[matchbox.d/etc/matchbox/README.md][9] for more details.

Ensure root SSH access to the EdgeRouter Lite assumed to be at
ubnt.lukeaddison.co.uk:
```sh
# configure ubnt authorized_keys
configure
loadkey ubnt id_rsa.pub
exit
```

Compile vault for linux/mips64 and move to `vault.d/vault`. Instructions can be
found [here](vault.d/README.md).

## Installation

To install this repository into your EdgeRouter Lite, place the contents of the
repository into the `/config/scripts/post-config.d` directory and run the
scripts in the root directory. Doing this also protects against any changes
introduced by upgrading EdgeOS.

```
rsync -qza --delete --exclude=.git . root@ubnt.lukeaddison.co.uk:/config/scripts/post-config.d/
ssh root@ubnt.lukeaddison.co.uk sh /config/scripts/post-config.d/dnsmasq.sh
ssh root@ubnt.lukeaddison.co.uk sh /config/scripts/post-config.d/matchbox.sh
ssh root@ubnt.lukeaddison.co.uk sh /config/scripts/post-config.d/vault.sh
```

If you want to use a cached copy of Container Linux for PXE booting using
`matchbox`, you will need to download a copy of [Container Linux][5] using the
[get-coreos][6] script and place it in the `/var/lib/matchbox/assets` directory.
The directory structure should look something like
`matchbox.d/assets/coreos/1520.8.0/...`.

  [1]: https://www.ubnt.com/edgemax/edgerouter-lite/
  [2]: http://www.thekelleys.org.uk/dnsmasq/doc.html
  [3]: https://github.com/coreos/matchbox
  [4]: https://github.com/dippynark/kube-matchbox-tf
  [5]: https://coreos.com/os/docs/latest/
  [6]: https://github.com/coreos/matchbox/blob/master/scripts/get-coreos
  [7]: ./matchbox.d/assets/README.md
  [8]: https://github.com/coreos/matchbox/blob/master/scripts/tls/cert-gen
  [9]: ./matchbox.d/etc/matchbox/README.md
  [10]: https://www.vaultproject.io/
