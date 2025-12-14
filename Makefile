# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileContributor: Adrian "asie" Siekierka, 2024

export BLOCKSDS ?= /opt/blocksds/core
export WONDERFUL_TOOLCHAIN ?= /opt/wonderful

# Tools
# -----

NDSTOOL		:= $(BLOCKSDS)/tools/ndstool/ndstool
CP		:= cp
MAKE		:= make
MKDIR		:= mkdir
RM		:= rm -rf

# Verbose flag
# ------------

ifeq ($(VERBOSE),1)
V		:=
else
V		:= @
endif

# Build rules
# -----------

ROM_MASS_STORAGE		:= dspico-mass-storage.nds
ROM_USB_SPEAKER			:= dspico-usb-speaker.nds
ROM_USB_VIDEO			:= dspico-usb-video.nds

.PHONY: all clean mass_storage_arm9 mass_storage_arm7 usb_speaker_arm9 usb_speaker_arm7 usb_video_arm9 usb_video_arm7 libtwl

all: $(ROM_MASS_STORAGE) $(ROM_USB_SPEAKER) $(ROM_USB_VIDEO)

$(ROM_MASS_STORAGE): mass_storage_arm7 mass_storage_arm9
	@$(MKDIR) -p $(@D)
	@echo "  NDSTOOL $@"
	$(V)$(BLOCKSDS)/tools/ndstool/ndstool -c $@ \
		-9 build/mass-storage/arm9.elf -7 build/mass-storage/arm7.elf \
		-b examples/mass-storage/icon.bmp "USB Mass Storage Example;DSpico;LNH team"

$(ROM_USB_SPEAKER): usb_speaker_arm7 usb_speaker_arm9
	@$(MKDIR) -p $(@D)
	@echo "  NDSTOOL $@"
	$(V)$(BLOCKSDS)/tools/ndstool/ndstool -c $@ \
		-9 build/usb-speaker/arm9.elf -7 build/usb-speaker/arm7.elf \
		-b examples/usb-speaker/icon.bmp "USB Speaker Example;DSpico;LNH team"

$(ROM_USB_VIDEO): usb_video_arm7 usb_video_arm9
	@$(MKDIR) -p $(@D)
	@echo "  NDSTOOL $@"
	$(V)$(BLOCKSDS)/tools/ndstool/ndstool -c $@ \
		-9 build/usb-video/arm9.elf -7 build/usb-video/arm7.elf \
		-b examples/usb-video/icon.bmp "USB Video Example;DSpico;LNH team"

libtwl:
	$(V)+$(MAKE) -C libs/libtwl

mass_storage_arm9: libtwl
	$(V)+$(MAKE) -f Makefile.arm9 TARGET=mass-storage --no-print-directory

mass_storage_arm7: libtwl
	$(V)+$(MAKE) -f Makefile.arm7 TARGET=mass-storage --no-print-directory

usb_speaker_arm9: libtwl
	$(V)+$(MAKE) -f Makefile.arm9 TARGET=usb-speaker --no-print-directory

usb_speaker_arm7: libtwl
	$(V)+$(MAKE) -f Makefile.arm7 TARGET=usb-speaker --no-print-directory

usb_video_arm9: libtwl
	$(V)+$(MAKE) -f Makefile.arm9 TARGET=usb-video --no-print-directory

usb_video_arm7: libtwl
	$(V)+$(MAKE) -f Makefile.arm7 TARGET=usb-video --no-print-directory

clean:
	@echo "  CLEAN"
	$(V)$(MAKE) -f Makefile.arm9 clean --no-print-directory
	$(V)$(MAKE) -f Makefile.arm7 clean --no-print-directory
	$(V)$(MAKE) -C libs/libtwl clean --no-print-directory
	$(V)$(RM) $(ROM_MASS_STORAGE) $(ROM_USB_SPEAKER) $(ROM_USB_VIDEO) build $(SDIMAGE)
