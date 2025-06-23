echo "================================================================================"
echo "[Chezmoi] windows install user font"
$userFontPath = "$HOME\AppData\Local\Microsoft\Windows\Fonts"
$fontName = "{{ .nerdfontName }}"
$fontRegistryName = "CaskaydiaMono NF Regular (TrueType)"
$fontPath = "$userFontPath\$fontName"

If(Test-Path -Path $fontPath) {
	echo "Found $fontName in $userFontPath"
	echo "Adding to registry under the name $fontNameDisplay"
	reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v $fontRegistryName /t REG_SZ /d $fontPath
	reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
}

