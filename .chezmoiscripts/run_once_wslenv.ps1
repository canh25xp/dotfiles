# batch style
# setx WSLENV "USERPROFILE/p:LOCALAPPDATA/p"

# powershell style
[Environment]::SetEnvironmentVariable("WSLENV", "USERPROFILE/p:LOCALAPPDATA/p", [System.EnvironmentVariableTarget]::User)
