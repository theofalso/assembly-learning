# Assembly Learning

A curated collection of small x86 assembly projects and exercises designed for learning low-level programming, BIOS/boot development, and simple operating system concepts. The repository contains example programs, boot sectors, and an early-stage hobby OS with build scripts and notes.


## About

This repository is a hands-on learning collection. Each numbered folder is a focused exercise that demonstrates one concept (hello world, input/output, simple games, bootloader code, and a tiny OS). The materials are mainly targeted at learners using Windows (with WSL) or Linux environments.

## Quick start

Prerequisites (recommended):

- Windows with WSL (Ubuntu recommended) or a native Linux environment
- NASM (Netwide Assembler)
- GNU binutils (ld, objcopy) for linking/format conversions
- QEMU or Bochs to run boot/OS images in an emulator

Install on Ubuntu (WSL):

```powershell
# in WSL / Ubuntu
sudo apt update; sudo apt install -y nasm binutils qemu-system-x86
```

On Windows, many folders include `compilar.bat` to automate assembling/linking using your installed NASM and tools. You can also run the same commands inside WSL.

Note: Some examples are 16-bit (boot/real-mode) and some are 32/64-bit user programs; build flags differ. The examples below show general approaches — adapt the flags to the specific source.

## Resources

- See `useful-websites.txt` for curated external references used while building these exercises.
