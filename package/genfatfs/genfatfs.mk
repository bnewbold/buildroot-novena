################################################################################
#
# genfatfs
#
################################################################################

GENFATFS_VERSION = 5c9ef0078b379966d5532389b4f332cfabb9ccd0
GENFATFS_SITE    = https://github.com/xobs/genfatfs/tarball/$(GENFATFS_VERSION)

define GENFATFS_BUILD_CMDS
	$(MAKE) -C $(@D) 			\
		HOSTCC="$(TARGET_CC)"		\
		HOSTCFLAGS="$(TARGET_CFLAGS)"	\
		HOSTLDFLAGS="$(TARGET_LDFLAGS)"	\
		HOSTSTRIP=true
endef

define HOST_GENFATFS_BUILD_CMDS
	$(MAKE1) -C $(@D) 			\
		HOSTCC="$(HOSTCC)"		\
		HOSTCFLAGS="$(HOST_CFLAGS)"	\
		HOSTLDFLAGS="$(HOST_LDFLAGS)"
endef

define HOST_GENFATFS_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/genfatfs $(HOST_DIR)/usr/bin/genfatfs
endef

$(eval $(host-generic-package))
