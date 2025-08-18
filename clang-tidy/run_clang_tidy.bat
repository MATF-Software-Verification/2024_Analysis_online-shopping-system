@echo off
REM ============================================
REM Skripta za pokretanje clang-tidy nad Server i Client direktorijumima
REM i generisanje HTML izveštaja
REM ============================================

REM Putanja do submodula 
set SUBMODULE_DIR=..\online-shopping-system\

REM Fajl gde ce se sacuvati tekstualni rezultati
set OUTPUT_FILE=clang_tidy_report.txt

REM Fajl gde ce se sacuvati HTML izvestaj
set OUTPUT_HTML=clang_tidy_report.html

REM Brisemo prethodne fajlove ako postoje
if exist %OUTPUT_FILE% del %OUTPUT_FILE%
if exist %OUTPUT_HTML% del %OUTPUT_HTML%

REM Specifične opcije za clang-tidy
REM -header-filter filtrira samo fajlove unutar SUBMODULE_DIR (Server i Client)
set CLANG_TIDY_OPTIONS=-checks=clang-diagnostic-*,clang-analyzer-*,modernize-use-auto,modernize-use-nullptr,modernize-use-noexcept,modernize-use-emplace,modernize-use-emplace-back,modernize-loop-convert,modernize-use-using -header-filter=".*(Server|Client).*"

echo Pokrecem clang-tidy analizu...

REM Rekurzivno analiziramo sve .cpp i .h fajlove u Server i Client
for /R %SUBMODULE_DIR%\Server %%f in (*.cpp *.h) do (
    echo [Processing] %%f
    clang-tidy "%%f" %CLANG_TIDY_OPTIONS% -- -I"%SUBMODULE_DIR%\Server\Headers" >> %OUTPUT_FILE% 2>&1
)

for /R %SUBMODULE_DIR%\Client %%f in (*.cpp *.h) do (
    echo [Processing] %%f
    clang-tidy "%%f" %CLANG_TIDY_OPTIONS% -- -I"%SUBMODULE_DIR%\Client\Headers" >> %OUTPUT_FILE% 2>&1
)

echo Analiza zavrsena. Rezultati su u fajlu %OUTPUT_FILE%

REM Generisanje HTML izvestaja iz txt fajla koristeci pandoc
echo Generisem HTML izvestaj...
pandoc %OUTPUT_FILE% -o %OUTPUT_HTML%

echo HTML izvestaj sacuvan u %OUTPUT_HTML%

pause
