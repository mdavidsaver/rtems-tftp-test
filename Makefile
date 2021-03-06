#
#  $Id$
#
# Templates/Makefile.leaf
# 	Template leaf node Makefile
#

# C source names, if any, go here -- minus the .c
C_PIECES=init config netconfig
C_FILES=$(C_PIECES:%=%.c)
C_O_FILES=$(C_PIECES:%=${ARCH}/%.o)

SRCS=$(C_FILES) $(CC_FILES) $(H_FILES) $(S_FILES)
OBJS=$(C_O_FILES) $(CC_O_FILES) $(S_O_FILES)

PGMS=${ARCH}/tftp-test.exe

MANAGERS=all

include $(RTEMS_MAKEFILE_PATH)/Makefile.inc

include $(RTEMS_CUSTOM)
include $(RTEMS_ROOT)/make/leaf.cfg

#
# (OPTIONAL) Add local stuff here using +=
#

DEFINES  +=
CPPFLAGS += -DBSP_$(RTEMS_BSP)
CFLAGS   +=

#
# CFLAGS_DEBUG_V are used when the `make debug' target is built.
# To link your application with the non-optimized RTEMS routines,
# uncomment the following line:
# CFLAGS_DEBUG_V += -qrtems_debug
#

#LD_PATHS  += xxx-your-EXTRA-library-paths-go-here, if any
#LD_LIBS   += xxx-your-libraries-go-here eg: -lvx
#LDFLAGS   +=

#
# Add your list of files to delete here.  The config files
#  already know how to delete some stuff, so you may want
#  to just run 'make clean' first to see what gets missed.
#  'make clobber' already includes 'make clean'
#

#CLEAN_ADDITIONS += xxx-your-debris-goes-here
CLOBBER_ADDITIONS +=

all:	${ARCH} $(SRCS) $(PGMS)

# The following links using C rules.
${ARCH}/tftp-test.exe: ${OBJS} ${LINK_FILES}
	$(make-exe)

# The following links using C++ rules to get the C++ libraries.
# Be sure you BSP has a make-cxx-exe rule if you use this.
# ${ARCH}/xxx-your-program-here: ${OBJS} ${LINK_FILES}
# 	$(make-cxx-exe)

# Install the program(s), appending _g or _p as appropriate.
# for include files, just use $(INSTALL_CHANGE)
install:  all
	$(INSTALL_VARIANT) -m 555 ${PGMS} ${PROJECT_RELEASE}/bin

QEMU ?= qemu-system-$(QEMU_ARCH)
QEMU_ARCH ?= i386
QEMUEXT  ?= .exe
QEMU_NIC ?= -net nic,model=ne2k_isa
QEMU_BSP ?=

QEMU_COMMON = -no-reboot -m 128 -serial stdio -kernel ${ARCH}/tftp-test$(QEMUEXT)
QEMU_NET = -net user,tftp=$$PWD/data
QEMU_RTEMS = --append '--console=com1'

QEMUCMD = $(QEMU) $(QEMU_COMMON) $(QEMU_BSP) $(QEMU_NIC) $(QEMU_NET) $(QEMU_RTEMS)

run::
	$(QEMUCMD)

run-gdb::
	$(QEMUCMD) -s -S
