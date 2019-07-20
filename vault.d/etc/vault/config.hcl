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
    tls_client_ca_file = "/etc/vault/ca.crt"
    tls_require_and_verify_client_cert = true
}

cluster_name = "home"

disable_mlock = true
