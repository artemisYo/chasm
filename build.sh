#!/bin/sh

nasm -felf64 -g -F dwarf ch.asm
ld -o ch ch.o
