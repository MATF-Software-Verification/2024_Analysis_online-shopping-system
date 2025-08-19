@echo off
setlocal

REM Podesi putanje do foldera sa kodom
set SOURCE_DIR=..\online-shopping-system
set SERVER_DIR=%SOURCE_DIR%\Server
set CLIENT_DIR=%SOURCE_DIR%\Client

REM Folder za izvestaje
set REPORT_DIR=cppcheck_html
set XML_FILE=cppcheck_results.xml

echo === Pokrecem cppcheck analizu... ===
cppcheck --enable=all --inconclusive --std=c++17 --force ^
  --xml %SERVER_DIR% %CLIENT_DIR% 2> %XML_FILE%

if %ERRORLEVEL% neq 0 (
    echo [UPOZORENJE] cppcheck je prijavio greske tokom analize.
)


endlocal
pause
