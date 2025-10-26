@echo off
set "FILENAME=calculator"
wsl nasm -f elf64 "%FILENAME%.asm" -o "%FILENAME%.o"


wsl ld "%FILENAME%.o" -o "%FILENAME%"
wsl ./"%FILENAME%"
pause