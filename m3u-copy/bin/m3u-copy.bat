@ECHO OFF
IF NOT EXIST "%~dp0jruby.exe" GOTO :TRUNK
@"%~dp0jruby.exe" -S "%~dpn0" %*
GOTO :EOF
:TRUNK
jruby.exe -S m3u-copy %*



