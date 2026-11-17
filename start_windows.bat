@echo off
rem ScholarBot launcher for Windows - double-click it or run it from a terminal. No administrator rights needed.
setlocal EnableExtensions
chcp 65001 >nul 2>&1
cd /d "%~dp0"
title ScholarBot

echo.
echo === ScholarBot (Windows) ===

rem --- 1/2. Python present and 3.11 or newer ---------------------------------------------------------
set "PY="
where py >nul 2>&1
if not errorlevel 1 (
  py -3 -c "import sys; sys.exit(0 if sys.version_info>=(3,11) else 1)" >nul 2>&1
  if not errorlevel 1 set "PY=py -3"
)
if not defined PY (
  where python >nul 2>&1
  if not errorlevel 1 (
    python -c "import sys; sys.exit(0 if sys.version_info>=(3,11) else 1)" >nul 2>&1
    if not errorlevel 1 set "PY=python"
  )
)
if not defined PY (
  echo.
  echo [ERROR] Python 3.11 or newer was not found.
  echo         Install it from https://www.python.org/downloads/ and tick "Add python.exe to PATH", then run this file again.
  goto :fail
)
for /f "delims=" %%v in ('%PY% --version') do echo Using %%v

rem --- 3. virtual environment (created only if missing) ---------------------------------------------
if not exist ".venv\Scripts\python.exe" (
  echo.
  echo ==^> Creating virtual environment ^(.venv^)
  %PY% -m venv .venv
  if errorlevel 1 (
    echo [ERROR] Could not create the virtual environment.
    goto :fail
  )
)
call ".venv\Scripts\activate.bat"

rem --- 4. pip ------------------------------------------------------------------------------------------
echo.
echo ==^> Updating pip
python -m pip install --quiet --disable-pip-version-check --upgrade pip
if errorlevel 1 echo [WARN] Could not update pip - continuing.

rem --- 5. .env from .env.example -----------------------------------------------------------------------
if not exist ".env" (
  echo.
  echo ==^> Creating .env from .env.example
  copy /y ".env.example" ".env" >nul
)

rem --- 6. dependencies from requirements.txt (+ local session key in .env) ------------------------------
echo.
echo ==^> Installing dependencies and checking .env
python tools\bootstrap.py
if errorlevel 1 goto :fail

rem --- 7. database migrations ------------------------------------------------------------------------------
echo.
echo ==^> Applying database migrations
python -m app.cli migrate
if errorlevel 1 goto :fail

rem --- 8. first administrator (asks interactively only when none exists yet) ------------------------------
echo.
echo ==^> Checking administrator account
python -m app.cli create-admin --if-none
if errorlevel 1 goto :fail

echo.
echo ==^> Configuration summary
python -m app.cli check
echo.
echo To enable the Bale bot, put its token in .env (BALE_BOT_TOKEN=...) or in Dashboard ^> Settings, then restart.

rem --- 9. run (the dashboard address is printed below; press Ctrl+C to stop) --------------------------------
echo.
echo ==^> Starting ScholarBot (press Ctrl+C to stop)
python run.py
if errorlevel 1 goto :fail
goto :done

:fail
echo.
echo ScholarBot could not start. Read the message above, or see "Troubleshooting" in README.md.
echo Common causes: no internet during the first run, the port is already in use ^(change DASHBOARD_PORT in .env^).
pause
exit /b 1

:done
endlocal
