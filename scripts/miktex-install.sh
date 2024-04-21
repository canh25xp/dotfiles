# https://miktex.org/download
curl -fsSL https://miktex.org/download/key | sudo tee /usr/share/keyrings/miktex-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/miktex-keyring.asc] https://miktex.org/download/debian bookworm universe" | sudo tee /etc/apt/sources.list.d/miktex.list
sudo apt-get update
sudo apt-get install miktex
miktexsetup finish
initexmf --set-config-value [MPM]AutoInstall=1
miktex
