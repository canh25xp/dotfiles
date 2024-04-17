# https://miktex.org/download
curl -fsSL https://miktex.org/download/key | sudo tee /usr/share/keyrings/miktex-keyring.asc > /dev/null
sudo apt-get update
sudo apt-get install miktex
miktexsetup finish
initexmf --set-config-value [MPM]AutoInstall=1
miktex
