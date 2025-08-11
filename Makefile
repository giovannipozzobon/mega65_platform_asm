
RM    = rm
JAVA  = /usr/bin/java
KSJAR = /Applications/KickAssembler/KickAss65CE02-5.25.jar
KS    = $(JAVA) -jar $(KSJAR)
C1541 = c1541
XEMU   = /Applications/Mega65/xmega65.app/Contents/MacOS/xmega65
ETHLOAD   = etherload.osx
M65FTP    = mega65_ftp.osx
M65    = m65.osx


LIBDIR = ./include
ALLPRG = main.prg

.PHONY: all clean

all: $(ALLPRG)

run: main.prg
#	$(M65FTP)  $(ETHLOAD_IP_PARAM) -e -c"put dj.d81"
#	$(ETHLOAD) $(ETHLOAD_IP_PARAM) -m dj.d81 -r runtime.raw
	$(M65) -l /dev/cu.usbserial-B002YK9V -@main.prg@2001

xemu: main.prg
	$(XEMU) -curskeyjoy -uartmon :4510 -prg main.prg

clean:
# remove all generated files
	$(RM) -f *.lst *.log *.sym $(ALLPRG)

%.prg: %.asm #$(LIBDIR)/*.asm
	@echo "Deleting file $*.asm"
	$(RM) -f *.lst *.log *.sym $(ALLPRG)
	@echo "Assembling $*.asm"
	#$(KS) -libdir $(LIBDIR) $*.asm -log $*.log -symbolfile  -bytedumpfile $*.klist 2> /dev/null 
	$(KS) $*.asm -log $*.log -symbolfile  -bytedumpfile $*.klist 2> /dev/null 