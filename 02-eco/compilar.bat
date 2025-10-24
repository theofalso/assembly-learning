@echo off
set "FILENAME=eco"
wsl nasm -f elf64 "%FILENAME%.asm" -o "%FILENAME%.o"


wsl ld "%FILENAME%.o" -o "%FILENAME%"
wsl ./"%FILENAME%"
echo.
pause