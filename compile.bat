@echo off

:: sources
bin\ca65 -g --debug-info -I src -o obj/main.o src/main.s -DCHR_CHIPS=1

:: libraries

:: link
bin\ld65 -o "roms/send-receive-antoine.nes" -C nes.cfg --dbgfile "roms/send-receive-antoine.dbg" obj/main.o
