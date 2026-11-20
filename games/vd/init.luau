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
-- SERVER
--================================================================--

local server = hub:AddTab({ name = "Server", icon = "list" })
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
			val = player.Team and player.Team.Name or player:GetAttribute("Team")
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
	lbl.Size = UDim2.new(1, -48, 1, 0)
	lbl.Position = UDim2.fromOffset(44, 0)
	lbl.Parent = entry

	entry.MouseEnter:Connect(function()
		H.tween(entry, { BackgroundColor3 = Theme.colors.hover })
	end)
	entry.MouseLeave:Connect(function()
		H.tween(entry, { BackgroundColor3 = Theme.colors.surface })
	end)
	entry.MouseButton1Click:Connect(function()
		openDetail(player)
	end)

	playerEntries[player] = entry
end

local function removePlayerEntry(player)
	local entry = playerEntries[player]
	if entry then
		entry:Destroy()
		playerEntries[player] = nil
	end
	if selectedPlayer == player then
		closeDetail()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	createPlayerEntry(player)
end

Players.PlayerAdded:Connect(createPlayerEntry)
Players.PlayerRemoving:Connect(removePlayerEntry)

hub:Show()

return {}
