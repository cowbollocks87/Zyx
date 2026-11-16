--[[ Zyx — Violence District ]]--

local UI = require(script.Parent.Parent.shared.ui)

local hub = UI.new({
	title = "Zyx \u{2014} Violence District",
	keybind = Enum.KeyCode.RightControl,
})

local home = hub:AddTab("Home")
local section = home:AddSection("Info")
section:AddLabel({ text = "Violence District loaded." })

hub:Show()

return {}
