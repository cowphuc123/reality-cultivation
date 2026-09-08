@echo off
setlocal
title Reality Cultivation Launcher

set "PROJECT_DIR=%~dp0client"
set "WEB_DIR=%PROJECT_DIR%\build\web"
set "PYTHON_EXE=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
set "GAME_URL=http://127.0.0.1:7357"

if not exist "%WEB_DIR%\index.html" (
  echo.
  echo Chua co ban game da dong goi tai:
  echo %WEB_DIR%
  echo.
  echo Hay mo Codex va yeu cau: "build lai game".
  echo.
  pause
  exit /b 1
)

if not exist "%PYTHON_EXE%" (
  echo.
  echo Khong tim thay bo chay web cuc bo.
  echo Hay mo Codex va yeu cau: "sua file MO_GAME.bat".
  echo.
  pause
  exit /b 1
)

cd /d "%PROJECT_DIR%"
start "Reality Cultivation - Local Server" /min "%PYTHON_EXE%" -m http.server 7357 --bind 127.0.0.1 --directory "%WEB_DIR%"
timeout /t 2 /nobreak >nul
start "" "%GAME_URL%"

echo Reality Cultivation dang mo tai %GAME_URL%
echo Neu muon tat may chu game, dong cua so "Reality Cultivation - Local Server".
timeout /t 4 /nobreak >nul
endlocal

