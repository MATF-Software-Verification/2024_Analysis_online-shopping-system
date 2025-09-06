@echo off
setlocal enabledelayedexpansion

set "SUBMODULE_DIR=..\online-shopping-system"
set "OUTPUT_FILE=clang_tidy_report.txt"
set "OUTPUT_HTML=clang_tidy_report.html"

if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%"
if exist "%OUTPUT_HTML%" del "%OUTPUT_HTML%"

set "TIDY_CHECKS=clang-diagnostic-*,clang-analyzer-*,modernize-use-auto,modernize-use-nullptr,modernize-use-noexcept,modernize-use-emplace,modernize-use-emplace-back,modernize-loop-convert,modernize-use-using"
set "HEADER_FILTER=.*(\\Server|\\Client).*"

REM TODO: PRILAGODI PUTANJE ispod tvom Windows SDK/MSVC okruzenju!
set "WINSDK_INC=C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0"
set "MSVC_INC=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.16.27023\include"

set "COMMON_ARGS=-std=c++17 -DWIN32 -D_UNICODE -DUNICODE -fms-compatibility -EHsc"
set "INCLUDES=-I"%WINSDK_INC%\ucrt" -I"%WINSDK_INC%\shared" -I"%WINSDK_INC%\um" -I"%WINSDK_INC%\winrt" -I"%MSVC_INC%""

echo Pokrecem clang-tidy (fallback nacin, bez compile_commands) ...

for /R "%SUBMODULE_DIR%\Server" %%f in (*.cpp) do (
  echo [Processing] %%f
  clang-tidy "%%f" -checks="%TIDY_CHECKS%" -header-filter="%HEADER_FILTER%" -- %COMMON_ARGS% %INCLUDES% -I"%SUBMODULE_DIR%\Server\Headers" >> "%OUTPUT_FILE%" 2>&1
)

for /R "%SUBMODULE_DIR%\Client" %%f in (*.cpp) do (
  echo [Processing] %%f
  clang-tidy "%%f" -checks="%TIDY_CHECKS%" -header-filter="%HEADER_FILTER%" -- %COMMON_ARGS% %INCLUDES% -I"%SUBMODULE_DIR%\Client\Headers" >> "%OUTPUT_FILE%" 2>&1
)

pandoc "%OUTPUT_FILE%" -o "%OUTPUT_HTML%" 2>nul
echo Gotovo. Rezultati: %OUTPUT_FILE%
endlocal
