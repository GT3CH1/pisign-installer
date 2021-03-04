#!/bin/bash
if [[ "$EUID" -ne 0 ]]; then
echo "Run this script with sudo. "
exit 1
fi
apt update -y
apt install git mongodb ffmpeg imagemagick -y
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt install nodejs -y
git clone https://github.com/colloqi/pisignage-server
mkdir -p media/_thumbnails
chown pi:pi -R media
cd pisignage-server
npm install

cat > /etc/systemd/system/pisign.service << EOF
[Unit]
Description=PiSignage server

[Service]
Type=simple
WorkingDirectory=/home/pi/pisignage-server
ExecStart=node server.js
Restart=always
User=pi

[Install]
WantedBy=network.target
EOF
chown pi:pi -R /home/pi/pisignage-server
chmod 755 -R /home/pi/pisignage-server
systemctl enable --now pisign
