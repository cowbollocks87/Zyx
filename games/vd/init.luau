--[[ Zyx — Violence District ]]--

local Players = game:GetService("Players")

local UI = require(script.Parent.Parent.shared.ui)
local Theme = UI.Theme
local Card = UI.Card
local InfoRow = UI.InfoRow
local H = UI.Helpers

local localPlayer = Players.LocalPlayer

local executorName, executorVersion = "Unknown", "?"
pcall(function()
	if identifyexecutor then
		executorName, executorVersion = identifyexecutor()
	end
end)

local hwid = "N/A"
pcall(function()
	if gethwid then hwid = gethwid()
	elseif getHWID then hwid = getHWID() end
end)

local hub = UI.new({
	title = "Zyx \u{2014} Violence District",
	keybind = Enum.KeyCode.RightControl,
	accent = Color3.fromRGB(180, 60, 60),
})

local thumbCache = {}
local function loadThumb(img, userId)
	if thumbCache[userId] then
		img.Image = thumbCache[userId]
		return
	end
	task.spawn(function()
		local ok, content = pcall(Players.GetUserThumbnailAsync, Players,
			userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		if ok and type(content) == "string" then
			thumbCache[userId] = content
			img.Image = content
		end
	end)
end

local TEAM_COLORS = {
	Killer    = Color3.fromRGB(220, 50, 50),
	Survivor  = Color3.fromRGB(60, 130, 220),
	Spectator = Color3.fromRGB(180, 180, 190),
}
local TEAM_COLOR_DEFAULT = Color3.fromRGB(100, 100, 110)

local function getTeamName(player)
	if player.Team then return player.Team.Name end
	local attr = player:GetAttribute("Team")
	if attr then return tostring(attr) end
	return "Unknown"
end

local function getTeamColor(teamName)
	return TEAM_COLORS[teamName] or TEAM_COLOR_DEFAULT
end

--================================================================--
-- DASHBOARD
--================================================================--

local dashboard = hub:AddTab({ name = "Dashboard", icon = "grid" })
local dashPage = dashboard:GetPage()

local dashContent = Instance.new("Frame")
dashContent.BackgroundTransparency = 1
dashContent.BorderSizePixel = 0
dashContent.Size = UDim2.new(1, -20, 1, -20)
dashContent.Position = UDim2.fromOffset(10, 10)
dashContent.Parent = dashPage

local leftCol = Instance.new("Frame")
leftCol.BackgroundTransparency = 1
leftCol.BorderSizePixel = 0
leftCol.Size = UDim2.new(0.5, -5, 1, 0)
leftCol.Parent = dashContent

local rightCol = Instance.new("Frame")
rightCol.BackgroundTransparency = 1
rightCol.BorderSizePixel = 0
rightCol.Size = UDim2.new(0.5, -5, 1, 0)
rightCol.Position = UDim2.new(0.5, 5, 0, 0)
rightCol.Parent = dashContent

-- Account Overview
local accountCard = Card.new({ name = "Account Overview" }, leftCol)
local acContent = accountCard:GetContent()

local avatarRow = Instance.new("Frame")
avatarRow.BackgroundTransparency = 1
avatarRow.BorderSizePixel = 0
avatarRow.Size = UDim2.new(1, 0, 0, 44)
avatarRow.Parent = acContent

local avatar = Instance.new("ImageLabel")
avatar.BackgroundColor3 = Theme.colors.elevated
avatar.BorderSizePixel = 0
avatar.Size = UDim2.fromOffset(36, 36)
avatar.Position = UDim2.fromOffset(0, 4)
avatar.Parent = avatarRow
H.corner(avatar, 18)

local nameLabel = Instance.new("TextLabel")
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Theme.colors.text
nameLabel.FontFace = Theme.font.bold
nameLabel.TextSize = Theme.font.title
nameLabel.Text = localPlayer.DisplayName .. " (" .. tostring(localPlayer.UserId) .. ")"
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.Size = UDim2.new(1, -44, 1, 0)
nameLabel.Position = UDim2.fromOffset(44, 0)
nameLabel.Parent = avatarRow

loadThumb(avatar, localPlayer.UserId)

-- Client Environment
local envCard = Card.new({ name = "Client Environment" }, rightCol)
envCard:AddInfoRow({ label = "Executor", value = executorName or "Unknown" })
envCard:AddInfoRow({ label = "Build Type", value = executorVersion and ("v" .. tostring(executorVersion)) or "?" })
envCard:AddInfoRow({ label = "HWID Status", value = hwid ~= "N/A" and "Locked" or "Unknown" })

--================================================================--
-- SERVER STATUS
--================================================================--

local server = hub:AddTab({ name = "Server Status", icon = "list" })
local serverPage = server:GetPage()

local DETAIL_WIDTH = 180

local playerList = Instance.new("ScrollingFrame")
playerList.Name = "PlayerList"
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.Size = UDim2.new(1, -8, 1, -8)
playerList.Position = UDim2.fromOffset(4, 4)
playerList.ScrollBarThickness = 3
playerList.ScrollBarImageColor3 = Theme.colors.border
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.Parent = serverPage
H.list(playerList, nil, 4)

-- Detail panel
local detailPanel = Instance.new("Frame")
detailPanel.Name = "DetailPanel"
detailPanel.BackgroundColor3 = Theme.colors.surface
detailPanel.BorderSizePixel = 0
detailPanel.Size = UDim2.new(0, DETAIL_WIDTH, 1, -8)
detailPanel.Position = UDim2.new(1, 0, 0, 4)
detailPanel.ZIndex = 5
detailPanel.ClipsDescendants = true
detailPanel.Parent = serverPage
H.corner(detailPanel, Theme.dim.cornerSmall)
H.stroke(detailPanel, Theme.colors.border, 1, 0.5)

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "\u{00D7}"
closeBtn.TextColor3 = Theme.colors.textMuted
closeBtn.FontFace = Theme.font.bold
closeBtn.TextSize = 16
closeBtn.BackgroundTransparency = 1
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Size = UDim2.fromOffset(20, 20)
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Position = UDim2.new(1, -6, 0, 6)
closeBtn.ZIndex = 6
closeBtn.Parent = detailPanel

local detailContent = Instance.new("Frame")
detailContent.BackgroundTransparency = 1
detailContent.BorderSizePixel = 0
detailContent.Size = UDim2.fromScale(1, 1)
detailContent.Parent = detailPanel
H.list(detailContent, nil, 8)
H.pad(detailContent, 12, 12, 12, 12)

local thumbWrap = Instance.new("Frame")
thumbWrap.BackgroundTransparency = 1
thumbWrap.BorderSizePixel = 0
thumbWrap.Size = UDim2.new(1, 0, 0, 64)
thumbWrap.LayoutOrder = 0
thumbWrap.Parent = detailContent

local detailThumb = Instance.new("ImageLabel")
detailThumb.BackgroundColor3 = Theme.colors.elevated
detailThumb.BorderSizePixel = 0
detailThumb.Size = UDim2.fromOffset(64, 64)
detailThumb.AnchorPoint = Vector2.new(0.5, 0)
detailThumb.Position = UDim2.new(0.5, 0, 0, 0)
detailThumb.Parent = thumbWrap
H.corner(detailThumb, 32)

local detailName = Instance.new("TextLabel")
detailName.BackgroundTransparency = 1
detailName.TextColor3 = Theme.colors.text
detailName.FontFace = Theme.font.bold
detailName.TextSize = Theme.font.title
detailName.TextXAlignment = Enum.TextXAlignment.Center
detailName.TextWrapped = true
detailName.AutomaticSize = Enum.AutomaticSize.Y
detailName.Size = UDim2.new(1, 0, 0, 0)
detailName.LayoutOrder = 1
detailName.Parent = detailContent

local detailUsername = Instance.new("TextLabel")
detailUsername.BackgroundTransparency = 1
detailUsername.TextColor3 = Theme.colors.textSub
detailUsername.FontFace = Theme.font.regular
detailUsername.TextSize = Theme.font.small
detailUsername.TextXAlignment = Enum.TextXAlignment.Center
detailUsername.Size = UDim2.new(1, 0, 0, 14)
detailUsername.LayoutOrder = 2
detailUsername.Parent = detailContent

local detailSep = Instance.new("Frame")
detailSep.BackgroundColor3 = Theme.colors.border
detailSep.BackgroundTransparency = 0.5
detailSep.BorderSizePixel = 0
detailSep.Size = UDim2.new(1, 0, 0, 1)
detailSep.LayoutOrder = 3
detailSep.Parent = detailContent

local statsContainer = Instance.new("Frame")
statsContainer.BackgroundTransparency = 1
statsContainer.BorderSizePixel = 0
statsContainer.AutomaticSize = Enum.AutomaticSize.Y
statsContainer.Size = UDim2.new(1, 0, 0, 0)
statsContainer.LayoutOrder = 4
statsContainer.Parent = detailContent
H.list(statsContainer, nil, 4)

local statRows = {}
local STAT_KEYS = { "Level", "Screws", "Gears", "EquippedItem", "Team" }
for _, key in ipairs(STAT_KEYS) do
	statRows[key] = InfoRow.new({ label = key, value = "--" }, statsContainer)
end

local selectedPlayer = nil
local detailOpen = false
local attrConns = {}

local function closeDetail()
	if not detailOpen then return end
	detailOpen = false
	selectedPlayer = nil
	H.tween(detailPanel, { Position = UDim2.new(1, 0, 0, 4) }, 0.2)
	H.tween(playerList, { Size = UDim2.new(1, -8, 1, -8) }, 0.2)
	for _, conn in ipairs(attrConns) do conn:Disconnect() end
	table.clear(attrConns)
end

local function updateStats(player)
	for _, key in ipairs(STAT_KEYS) do
		local val
		if key == "Team" then
			val = getTeamName(player)
		else
			val = player:GetAttribute(key)
		end
		statRows[key]:SetValue(val ~= nil and tostring(val) or "--")
	end
end

local function openDetail(player)
	if selectedPlayer == player then
		closeDetail()
		return
	end

	for _, conn in ipairs(attrConns) do conn:Disconnect() end
	table.clear(attrConns)

	selectedPlayer = player
	detailOpen = true

	detailName.Text = player.DisplayName
	detailUsername.Text = "@" .. player.Name
	detailThumb.Image = ""
	loadThumb(detailThumb, player.UserId)
	updateStats(player)

	for _, key in ipairs(STAT_KEYS) do
		if key == "Team" then
			table.insert(attrConns, player:GetPropertyChangedSignal("Team"):Connect(function()
				if selectedPlayer == player then
					statRows.Team:SetValue(player.Team and player.Team.Name or "--")
				end
			end))
		else
			table.insert(attrConns, player:GetAttributeChangedSignal(key):Connect(function()
				if selectedPlayer == player then
					statRows[key]:SetValue(tostring(player:GetAttribute(key) or "--"))
				end
			end))
		end
	end

	H.tween(detailPanel, { Position = UDim2.new(1, -(DETAIL_WIDTH + 4), 0, 4) }, 0.2)
	H.tween(playerList, { Size = UDim2.new(1, -(DETAIL_WIDTH + 14), 1, -8) }, 0.2)
end

closeBtn.MouseButton1Click:Connect(closeDetail)

local playerEntries = {}
local teamTagRefs = {}

local function updateTeamTag(player)
	local ref = teamTagRefs[player]
	if not ref then return end
	local teamName = getTeamName(player)
	local teamColor = getTeamColor(teamName)
	ref.label.Text = teamName
	ref.frame.BackgroundColor3 = teamColor
end

local function createPlayerEntry(player)
	local entry = Instance.new("TextButton")
	entry.Name = "Player_" .. player.Name
	entry.Text = ""
	entry.AutoButtonColor = false
	entry.BackgroundColor3 = Theme.colors.surface
	entry.BorderSizePixel = 0
	entry.Size = UDim2.new(1, 0, 0, 44)
	entry.Parent = playerList
	H.corner(entry, Theme.dim.cornerSmall)

	local thumb = Instance.new("ImageLabel")
	thumb.BackgroundColor3 = Theme.colors.elevated
	thumb.BorderSizePixel = 0
	thumb.Size = UDim2.fromOffset(32, 32)
	thumb.Position = UDim2.fromOffset(6, 6)
	thumb.Parent = entry
	H.corner(thumb, 16)
	loadThumb(thumb, player.UserId)

	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Theme.colors.text
	lbl.FontFace = Theme.font.medium
	lbl.TextSize = Theme.font.body
	lbl.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.Size = UDim2.new(1, -130, 1, 0)
	lbl.Position = UDim2.fromOffset(44, 0)
	lbl.Parent = entry

	-- Team tag
	local teamName = getTeamName(player)
	local teamColor = getTeamColor(teamName)

	local tag = Instance.new("Frame")
	tag.Name = "TeamTag"
	tag.BackgroundColor3 = teamColor
	tag.BackgroundTransparency = 0.7
	tag.BorderSizePixel = 0
	tag.AutomaticSize = Enum.AutomaticSize.X
	tag.Size = UDim2.new(0, 0, 0, 20)
	tag.AnchorPoint = Vector2.new(1, 0.5)
	tag.Position = UDim2.new(1, -10, 0.5, 0)
	tag.Parent = entry
	H.corner(tag, 3)
	H.pad(tag, 0, 6, 0, 6)

	local tagLabel = Instance.new("TextLabel")
	tagLabel.BackgroundTransparency = 1
	tagLabel.TextColor3 = teamColor
	tagLabel.FontFace = Theme.font.medium
	tagLabel.TextSize = 10
	tagLabel.Text = teamName
	tagLabel.TextXAlignment = Enum.TextXAlignment.Center
	tagLabel.AutomaticSize = Enum.AutomaticSize.X
	tagLabel.Size = UDim2.new(0, 0, 1, 0)
	tagLabel.Parent = tag

	teamTagRefs[player] = { frame = tag, label = tagLabel }

	-- Live team updates
	local teamConn = player:GetPropertyChangedSignal("Team"):Connect(function()
		updateTeamTag(player)
	end)

	entry.MouseEnter:Connect(function()
		H.tween(entry, { BackgroundColor3 = Theme.colors.hover })
	end)
	entry.MouseLeave:Connect(function()
		H.tween(entry, { BackgroundColor3 = Theme.colors.surface })
	end)
	entry.MouseButton1Click:Connect(function()
		openDetail(player)
	end)

	playerEntries[player] = { entry = entry, teamConn = teamConn }
end

local function removePlayerEntry(player)
	local ref = playerEntries[player]
	if ref then
		ref.teamConn:Disconnect()
		ref.entry:Destroy()
		playerEntries[player] = nil
	end
	teamTagRefs[player] = nil
	if selectedPlayer == player then
		closeDetail()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	createPlayerEntry(player)
end

Players.PlayerAdded:Connect(createPlayerEntry)
Players.PlayerRemoving:Connect(removePlayerEntry)

--================================================================--
-- UTILITY
--================================================================--

local utility = hub:AddTab({ name = "Utility", icon = "gear" })
local utilPage = utility:GetPage()

local utilContent = Instance.new("Frame")
utilContent.BackgroundTransparency = 1
utilContent.BorderSizePixel = 0
utilContent.Size = UDim2.new(1, -20, 1, -20)
utilContent.Position = UDim2.fromOffset(10, 10)
utilContent.Parent = utilPage

local utilLayout = Instance.new("UIListLayout")
utilLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilLayout.Padding = UDim.new(0, 10)
utilLayout.Parent = utilContent

-- Keybind display
local keybindCard = Card.new({ name = "Toggle Keybind" }, utilContent)
keybindCard:AddInfoRow({ label = "Show/Hide UI", value = "RightControl" })

-- Unload button
local unloadCard = Card.new({ name = "Script Control" }, utilContent)
local unloadContent = unloadCard:GetContent()

local unloadBtn = Instance.new("TextButton")
unloadBtn.Name = "Unload"
unloadBtn.Text = "Unload Script"
unloadBtn.AutoButtonColor = false
unloadBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
unloadBtn.BackgroundTransparency = 0.3
unloadBtn.TextColor3 = Theme.colors.text
unloadBtn.FontFace = Theme.font.medium
unloadBtn.TextSize = Theme.font.body
unloadBtn.BorderSizePixel = 0
unloadBtn.Size = UDim2.new(1, 0, 0, 32)
unloadBtn.Parent = unloadContent
H.corner(unloadBtn, Theme.dim.cornerSmall)

unloadBtn.MouseEnter:Connect(function()
	H.tween(unloadBtn, { BackgroundTransparency = 0.15 })
end)
unloadBtn.MouseLeave:Connect(function()
	H.tween(unloadBtn, { BackgroundTransparency = 0.3 })
end)
unloadBtn.MouseButton1Click:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		removePlayerEntry(player)
	end
	for _, conn in ipairs(attrConns) do conn:Disconnect() end
	hub:Destroy()
end)

hub:Show()

return {}
