## BGP configuration

https://blog.stonegarden.dev/articles/2025/11/bgp-cilium-unifi/
Todo:
Enable bgpControlPlane
Loadbalance API: https://github.com/siderolabs/talos/issues/8459#issuecomment-2016036078

```
router bgp 65100
  bgp router-id 10.0.1.1
  bgp ebgp-requires-policy

  neighbor k8s peer-group
  neighbor k8s remote-as 65200

  neighbor 10.0.20.150 peer-group k8s
  neighbor 10.0.20.150 bfd
  neighbor 10.0.20.151 peer-group k8s
  neighbor 10.0.20.151 bfd
  neighbor 10.0.20.152 peer-group k8s
  neighbor 10.0.20.152 bfd
  neighbor 10.0.20.160 peer-group k8s
  neighbor 10.0.20.161 peer-group k8s
  neighbor 10.0.20.162 peer-group k8s

  address-family ipv4 unicast
    redistribute connected
    neighbor k8s activate
    neighbor k8s next-hop-self
    neighbor k8s soft-reconfiguration inbound
    neighbor k8s route-map ALLOW-ALL in
    neighbor k8s route-map ALLOW-ALL out
  exit-address-family
exit

route-map ALLOW-ALL permit 10
exit
```
