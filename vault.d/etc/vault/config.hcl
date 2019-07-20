storage "file" {
  path = "/var/lib/vault"
}

listener "tcp" {
    address = "127.0.0.1:8200"
    tls_disable = 1
}

listener "tcp" {
    address = "192.168.1.1:8200"

    tls_cert_file = "/etc/vault/server.crt"
    tls_key_file = "/etc/vault/server.key"
}

cluster_name = "home"

disable_mlock = true
