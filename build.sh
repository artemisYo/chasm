#!/bin/sh

nasm -felf64 ch.asm
ld -o ch ch.o
