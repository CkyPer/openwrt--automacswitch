include $(TOPDIR)/rules.mk

PKG_NAME:=mac-switch
PKG_VERSION:=1.2.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/mac-switch
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Auto switch WAN MAC on network failure
  DEPENDS:=+luci-base +kmod-mac80211
  PKGARCH:=all
endef

define Package/mac-switch/description
  A LuCI application to automatically switch wireless/wired WAN MAC address when network is down.
endef

define Build/Compile
endef

define Package/mac-switch/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/mac-switch.sh $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/mac-switch $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./root/usr/lib/lua/luci/controller/mac-switch.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./root/usr/lib/lua/luci/model/cbi/mac-switch.lua $(1)/usr/lib/lua/luci/model/cbi/
endef

$(eval $(call BuildPackage,mac-switch))
