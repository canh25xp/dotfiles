# https://go.dev/doc/install
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin # Add to .bash_profile
