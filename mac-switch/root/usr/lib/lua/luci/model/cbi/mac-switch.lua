local m, s, o

m = Map("mac-switch", translate("MAC Auto Switch Settings"), translate("Configure automatic MAC address switching on network failure."))

s = m:section(TypedSection, "settings", translate("General Settings"))
s.anonymous = true
s.addremove = false

-- 1. 接口选择
o = s:option(ListValue, "interface", translate("Target Interface"), translate("Select the network interface to monitor and modify MAC."))
local fs = require "nixio.fs"
for iface in fs.dir("/sys/class/net") do
    if iface ~= "lo" then
        o:value(iface, iface)
    end
end
o:value("", translate("-- Please Select --"))

-- 2. MAC 前缀
o = s:option(Value, "mac_prefix", translate("MAC Prefix"), translate("Enter the first 3 octets (e.g., 00:11:22). The rest will be randomized."))
o.datatype = "macaddr"
o.placeholder = "00:11:22"
o.default = "00:11:22"

-- 3. 断网检查方式
o = s:option(ListValue, "check_method", translate("Check Method"), translate("How to detect network failure."))
o:value("ping", translate("Ping IP"))
o:value("http", translate("HTTP Request"))
o.default = "ping"

-- 4. 检查目标
o = s:option(Value, "check_target", translate("Check Target"), translate("IP address for Ping or URL for HTTP."))
o.default = "223.5.5.5"

-- 5. 检查间隔
o = s:option(Value, "interval", translate("Check Interval (minutes)"), translate("How often to check the network status."))
o.datatype = "uinteger"
o.default = 5

return m
