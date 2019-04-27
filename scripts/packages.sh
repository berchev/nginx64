mkdir -p /etc/dpkg/dpkg.cfg.d
cat >/etc/dpkg/dpkg.cfg.d/01_nodoc <<EOF
path-exclude /usr/share/doc/*
path-include /usr/share/doc/*/copyright
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF

export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"

apt-get clean ${APTARGS}
apt-get update ${APTARGS}

apt-get upgrade -y ${APTARGS}
apt-get dist-upgrade -y ${APTARGS}

# Update to the latest kernel
apt-get install -y linux-generic linux-image-generic ${APTARGS}

# build-essential
apt-get install -y build-essential ${APTARGS}

# for docker devicemapper
apt-get install -y thin-provisioning-tools ${APTARGS}

# some tools
apt-get install -y ${APTARGS} python-pip python3-pip git jq curl wget vim language-pack-en sysstat htop
apt-get install -y ${APTARGS} ruby ruby-dev

# Install and setup python3.6 as default + idle
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:jonathonf/python-3.6
apt-get update
apt-get install -y python3.6
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
echo -ne '\n' | update-alternatives --config python3

# Install all needed for Kitchen tool
apt-get install -y rbenv ruby-dev ruby-bundler
grep -i rbenv /home/vagrant/.bash_profile &>/dev/null || {
  touch /home/vagrant/.bash_profile
  chown vagrant.vagrant /home/vagrant/.bash_profile
  echo 'export eval "$(rbenv init -)"' | sudo tee -a /home/vagrant/.bash_profile
  echo 'true' | sudo tee -a /home/vagrant/.bash_profile
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | sudo tee -a /home/vagrant/.bash_profile
}

#Install nginx
apt-get update
apt-get install -y nginx

# prep for LXD
cat > /etc/security/limits.d/lxd.conf <<EOF
* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
* soft memlock unlimited
* hard memlock unlimited
EOF

cat > /etc/sysctl.conf <<EOF
fs.inotify.max_queued_events=1048576
fs.inotify.max_user_instances=1048576
fs.inotify.max_user_watches=1048576
vm.max_map_count=262144
kernel.dmesg_restrict=1
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv6.neigh.default.gc_thresh3=8192
EOF

# container top
wget https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -O /usr/local/bin/ctop
chmod +x /usr/local/bin/ctop

# Hide Ubuntu splash screen during OS Boot, so you can see if the boot hangs
apt-get remove -y plymouth-theme-ubuntu-text
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
update-grub

# Reboot with the new kernel
shutdown -r now
