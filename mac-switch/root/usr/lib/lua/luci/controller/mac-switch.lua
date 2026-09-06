module("luci.controller.mac-switch", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/mac-switch") then
        return
    end

    entry({"admin", "system", "mac-switch"}, alias("admin", "system", "mac-switch", "general"), _("MAC Auto Switch"), 60).dependent = true
    entry({"admin", "system", "mac-switch", "general"}, cbi("mac-switch"), _("Settings"), 10)
end
