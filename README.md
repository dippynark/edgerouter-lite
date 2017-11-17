# edgerouter-lite

This repository contains my modifications to the [EdgeRouter Lite][1]. The main changes are to use [dnsmasq][2] for DHCP and a SysV init script for [matchbox][3]. This allows me to PXE boot machines in my domain and integrate with my [kube-matchbox-tf][4] project.

## Prerequisites

In order to use `matchbox`, you first need to generate the CA and serving key pairs and place them in `matchbox.d/etc/matchbox`. To do this you can use the [cert-gen][8] script in the `matchbox` repository. Read [matchbox.d/etc/matchbox/README.md][9] for more details.

## Installation 

To install this repository into your EdgeRouter Lite, place the contents of the repository into the `/config/scripts/post-config.d` directory and run the scripts in the root directory. Doing this also protects against any changes introduced by upgrading EdgeOS. 

If you want to use a cached copy of Container Linux for PXE booting using `matchbox`, you will need to download a copy of [Container Linux][5] using the [get-coreos][6] script and place it in the `matchbox.d/assets` directory. Read [matchbox.d/assets/README.md][7] for more details.

  [1]: https://www.ubnt.com/edgemax/edgerouter-lite/
  [2]: http://www.thekelleys.org.uk/dnsmasq/doc.html
  [3]: https://github.com/coreos/matchbox
  [4]: https://github.com/dippynark/kube-matchbox-tf
  [5]: https://coreos.com/os/docs/latest/
  [6]: https://github.com/coreos/matchbox/blob/master/scripts/get-coreos
  [7]: ./matchbox.d/assets/README.md
  [8]: https://github.com/coreos/matchbox/blob/master/scripts/tls/cert-gen
  [9]: ./matchbox.d/etc/matchbox/README.md