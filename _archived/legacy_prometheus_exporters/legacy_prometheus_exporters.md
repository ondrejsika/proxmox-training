### Prometheus Monitoring

- [prometheus-pve/prometheus-pve-exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) (1.2k stars on Github, maintained)
- [wakeful/pve_exporter](https://github.com/wakeful/pve_exporter) (34 stars on Github, 6 years old last commit)

#### Install prometheus-pve-exporter (Python)

Install [pipx](https://pipx.pypa.io/)

```
apt-get install pipx
```

Install `prometheus-pve-exporter`

```
pipx install prometheus-pve-exporter
```

Create a config file `/etc/prometheus/pve.yml`

```
mkdir -p /etc/prometheus/
cat <<EOF > /etc/prometheus/pve.yml
default:
  user: root@pam
  password: xxx
  verify_ssl: false
EOF
```

Run exporter

```
/root/.local/bin/pve_exporter
```

Or create systemd service

```
cat <<EOF > /etc/systemd/system/prometheus-pve-exporter.service
[Unit]
Description=prometheus-pve-exporter
ConditionPathExists=/
After=network.target

[Service]
Type=simple

ExecStart=/root/.local/bin/pve_exporter
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

Start service

```
systemctl enable prometheus-pve-exporter
systemctl start prometheus-pve-exporter
```

or

```
systemctl enable prometheus-pve-exporter --now
```

#### Wakeful PVE Exporter (Go)

Install

```
wget -O /usr/local/bin/pve_exporter https://github.com/wakeful/pve_exporter/releases/download/0.1.6/pve_exporter-linux-amd64 && chmod +x /usr/local/bin/pve_exporter
```

Run on the node

```
pve_exporter -password <password>
```

Run on the other machine

```
pve_exporter -pve-url <pve_url> -password <password>
```

Listen on port 9090
