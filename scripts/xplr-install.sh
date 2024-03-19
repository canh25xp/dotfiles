#!/bin/sh

platform="linux"
wget https://github.com/sayanarijit/xplr/releases/latest/download/xplr-$platform.tar.gz
tar xzvf xplr-$platform.tar.gz
sudo install xplr /usr/local/bin
