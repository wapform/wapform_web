@echo off
title WapForm API (Flutter back end)
cd /d "%~dp0"
if not exist node_modules call npm install
node server.js
pause
