################################################################################
#
# maketools
#
################################################################################

MAKEDISK_VERSION = c343d8e8176482cf2302ea5d8e1974e9178eab83
MAKEDISK_SITE    = https://github.com/sutajiokousagi/makedisk/tarball/$(MAKEDISK_VERSION)

define MAKEDISK_BUILD_CMDS
	$(MAKE) -C $(@D) 			\
		HOSTCC="$(TARGET_CC)"		\
		HOSTCFLAGS="$(TARGET_CFLAGS)"	\
		HOSTLDFLAGS="$(TARGET_LDFLAGS)"	\
		HOSTSTRIP=true
endef

define HOST_MAKEDISK_BUILD_CMDS
	$(MAKE1) -C $(@D) 			\
		HOSTCC="$(HOSTCC)"		\
		HOSTCFLAGS="$(HOST_CFLAGS)"	\
		HOSTLDFLAGS="$(HOST_LDFLAGS)"
endef

define HOST_MAKEDISK_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/makedisk $(HOST_DIR)/usr/bin/makedisk
endef

$(eval $(host-generic-package))
