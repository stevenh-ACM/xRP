REM @ECHO OFF
SET ADVANCED_SITE_DIR=C:\src\temp2\erp\U302
cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\"
devenv.exe "%~dp0\#PROJECT#.sln %*"
