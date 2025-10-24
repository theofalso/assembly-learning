@echo off
set "FILENAME=hello-world"
wsl nasm -f elf64 "%FILENAME%.asm" -o "%FILENAME%.o"


wsl ld "%FILENAME%.o" -o "%FILENAME%"
wsl ./"%FILENAME%"
echo.
pause