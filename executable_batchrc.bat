:: This file is registered via registry to auto load with each instance of cmd.
:: [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor]
:: "AutoRun"="%USERPROFILE%\\batchrc.bat"
:: Or run 
:: reg add "HKLM\Software\Microsoft\Command Processor" /v Autorun /d "doskey /macrofile=\"%userprofile%\batch_aliases.mac"" /f
:: reg query "HKLM\Software\Microsoft\Command Processor" /v Autorun
:: Note : HKLM=HKEY_LOCAL_MACHINE ; HKCU=HKEY_CURRENT_USER

@echo off
:: doskey /macrofile=%userprofile%\batch_aliases.mac
IF EXIST "%USERPROFILE%\batch_aliases.bat" ( CALL "%USERPROFILE%\batch_aliases.bat" )

:: cls
echo You Look Lonely. I can fix that.