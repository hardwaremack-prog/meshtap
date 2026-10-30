@echo off
title MeshTap
cd /d "%~dp0"
set PY=python
where py >nul 2>nul && set PY=py
if not exist ".venv\Scripts\python.exe" (
  echo Setting up MeshTap for the first time...
  %PY% -m venv .venv || (echo Python 3 is needed - get it from python.org & pause & exit /b 1)
)
if not exist ".venv\installed.txt" (
  ".venv\Scripts\python.exe" -m pip install --upgrade pip
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt && echo ok> ".venv\installed.txt"
)
".venv\Scripts\python.exe" meshtap.py %*
pause
