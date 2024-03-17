:: Usefull commands
doskey alias=doskey /macros
doskey editalias=%EDITOR% %USERPROFILE%\batch_aliases.bat
doskey history=doskey /history
doskey ~=cd/d %USERPROFILE%
doskey wifi=netsh wlan show profile key=clear $*
doskey wtf=cd %USERPROFILE%\Documents\CheatSheets $T glow

:: Shortened commands
doskey arduino=arduino-cli $*
doskey np=notepad $*
doskey exp=explorer $*
doskey cdc=cd/d c:\
doskey cdd=cd/d d:\
doskey cde=cd/d e:\
doskey cdep=cd/d e:\Projects
doskey edit=%editor% $*

:: Attempts to mimic bash commands
doskey rd=rmdir /s /q $*
doskey ls=dir /b $*
doskey rm=del /q $*
doskey mv=move $*
doskey cp=copy $*
