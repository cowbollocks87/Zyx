--[[ Zyx UI Framework ]]--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Signal = require(script.Parent.utils.Signal)
local Trove = require(script.Parent.utils.Trove)

--================================================================--
-- THEME
--================================================================--

local Theme = {}

Theme.colors = {
	bg        = Color3.fromRGB(10, 10, 16),
	surface   = Color3.fromRGB(18, 18, 27),
	elevated  = Color3.fromRGB(28, 28, 40),
	hover     = Color3.fromRGB(34, 34, 48),
	border    = Color3.fromRGB(44, 44, 60),
	text      = Color3.fromRGB(228, 228, 234),
	textSub   = Color3.fromRGB(138, 138, 155),
	textMuted = Color3.fromRGB(78, 78, 100),
	accent    = Color3.fromRGB(255, 255, 255),
	shadow    = Color3.fromRGB(2, 2, 6),
	toggleOff = Color3.fromRGB(32, 32, 44),
}

Theme.font = {
	regular = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular),
	medium  = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
	bold    = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
	title   = 15,
	body    = 13,
	small   = 11,
}

Theme.dim = {
	corner       = 12,
	cornerSmall  = 8,
	windowWidth  = 540,
	windowHeight = 440,
	titleBar     = 42,
	footer       = 26,
	tabWidth     = 120,
	control      = 34,
	sectionGap   = 10,
	controlGap   = 4,
}

Theme.Changed = Signal.new()

function Theme:SetAccent(color)
	self.colors.accent = color
	self.Changed:Fire("accent", color)
end

--================================================================--
-- HELPERS
--================================================================--

local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function tween(inst, props, duration)
	local info = duration and TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or TWEEN
	TweenService:Create(inst, info, props):Play()
end

local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or Theme.dim.corner)
	c.Parent = inst
	return c
end

local function stroke(inst, color, weight, trans)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.colors.border
	s.Thickness = weight or 1
	s.Transparency = trans or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
	return s
end

local function gradient(inst, rotation, from, to)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(
		from or Color3.new(1, 1, 1),
		to or Color3.fromRGB(232, 232, 238)
	)
	g.Rotation = rotation or 90
	g.Parent = inst
	return g
end

local function list(parent, direction, gap)
	local l = Instance.new("UIListLayout")
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.FillDirection = direction or Enum.FillDirection.Vertical
	l.Padding = UDim.new(0, gap or 0)
	l.Parent = parent
	return l
end

local function pad(parent, t, r, b, l)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.PaddingLeft = UDim.new(0, l or 0)
	p.Parent = parent
	return p
end

local function getMouse()
	return UIS:GetMouseLocation()
end

--================================================================--
-- CONTROLS
--================================================================--

local function createToggle(config, parent)
	local trove = Trove.new()
	local value = config.default or false
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local row = Instance.new("Frame")
	row.Name = "Toggle_" .. (config.name or "")
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = colors.text
	label.FontFace = Theme.font.regular
	label.TextSize = Theme.font.body
	label.Text = config.name or ""
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -52, 1, 0)
	label.Parent = row

	local track = Instance.new("TextButton")
	track.Name = "Track"
	track.Text = ""
	track.AutoButtonColor = false
	track.BackgroundColor3 = value and colors.accent or colors.toggleOff
	track.BorderSizePixel = 0
	track.Size = UDim2.fromOffset(38, 20)
	track.Position = UDim2.new(1, -42, 0.5, -10)
	track.Parent = row
	corner(track, 10)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.BackgroundColor3 = value and colors.bg or colors.textSub
	knob.BorderSizePixel = 0
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = value and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
	knob.Parent = track
	corner(knob, 8)

	local function updateVisual()
		local on = value
		tween(track, { BackgroundColor3 = on and colors.accent or colors.toggleOff })
		tween(knob, {
			Position = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
			BackgroundColor3 = on and colors.bg or colors.textSub,
		})
	end

	trove:Connect(track.MouseButton1Click, function()
		value = not value
		updateVisual()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end)

	trove:Connect(Theme.Changed, function(key)
		if key == "accent" then updateVisual() end
	end)

	trove:Add(row)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(v)
		if v == value then return end
		value = v
		updateVisual()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end
	function ctrl:Get() return value end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createSlider(config, parent)
	local trove = Trove.new()
	local min = config.min or 0
	local max = config.max or 100
	local step = config.step
	local value = config.default or min
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local container = Instance.new("Frame")
	container.Name = "Slider_" .. (config.name or "")
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Size = UDim2.new(1, 0, 0, 48)
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = colors.text
	label.FontFace = Theme.font.regular
	label.TextSize = Theme.font.body
	label.Text = config.name or ""
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -40, 0, 20)
	label.Parent = container

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = colors.textSub
	valueLabel.FontFace = Theme.font.medium
	valueLabel.TextSize = Theme.font.body
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0, 36, 0, 20)
	valueLabel.Position = UDim2.new(1, -36, 0, 0)
	valueLabel.Parent = container

	local trackFrame = Instance.new("Frame")
	trackFrame.Name = "Track"
	trackFrame.BackgroundColor3 = colors.toggleOff
	trackFrame.BorderSizePixel = 0
	trackFrame.Size = UDim2.new(1, 0, 0, 4)
	trackFrame.Position = UDim2.fromOffset(0, 30)
	trackFrame.Parent = container
	corner(trackFrame, 2)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.BackgroundColor3 = colors.accent
	fill.BorderSizePixel = 0
	fill.Size = UDim2.fromScale(0, 1)
	fill.Parent = trackFrame
	corner(fill, 2)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.BackgroundColor3 = colors.accent
	knob.BorderSizePixel = 0
	knob.Size = UDim2.fromOffset(14, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.ZIndex = 2
	knob.Parent = trackFrame
	corner(knob, 7)

	local hitArea = Instance.new("TextButton")
	hitArea.Text = ""
	hitArea.BackgroundTransparency = 1
	hitArea.BorderSizePixel = 0
	hitArea.Size = UDim2.new(1, 0, 0, 24)
	hitArea.Position = UDim2.fromOffset(0, 20)
	hitArea.AutoButtonColor = false
	hitArea.Parent = container

	local function updateVisual()
		local alpha = math.clamp((value - min) / (max - min), 0, 1)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		local display = step and step < 1 and string.format("%.1f", value) or tostring(math.floor(value))
		valueLabel.Text = display
	end

	local function setValue(v)
		if step then v = math.floor(v / step + 0.5) * step end
		v = math.clamp(v, min, max)
		if v == value then return end
		value = v
		updateVisual()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end

	local function mouseToValue(mouseX)
		local alpha = math.clamp((mouseX - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1)
		return min + alpha * (max - min)
	end

	local dragging = false
	trove:Connect(hitArea.MouseButton1Down, function()
		dragging = true
		setValue(mouseToValue(getMouse().X))
	end)
	trove:Connect(UIS.InputChanged, function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			setValue(mouseToValue(getMouse().X))
		end
	end)
	trove:Connect(UIS.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	trove:Connect(Theme.Changed, function(key)
		if key == "accent" then
			fill.BackgroundColor3 = colors.accent
			knob.BackgroundColor3 = colors.accent
		end
	end)

	updateVisual()
	trove:Add(container)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(v) setValue(v) end
	function ctrl:Get() return value end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createDropdown(config, parent)
	local trove = Trove.new()
	local value = config.default or config.options[1]
	local expanded = false
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local container = Instance.new("Frame")
	container.Name = "Dropdown_" .. (config.name or "")
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.ClipsDescendants = false
	container.Parent = parent
	list(container, nil, 3)

	local header = Instance.new("TextButton")
	header.Name = "Header"
	header.Text = ""
	header.AutoButtonColor = false
	header.BackgroundColor3 = colors.elevated
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	header.LayoutOrder = 1
	header.Parent = container
	corner(header, Theme.dim.cornerSmall)
	stroke(header, colors.border, 1, 0.5)

	local headerLabel = Instance.new("TextLabel")
	headerLabel.BackgroundTransparency = 1
	headerLabel.TextColor3 = colors.textSub
	headerLabel.FontFace = Theme.font.regular
	headerLabel.TextSize = Theme.font.small
	headerLabel.Text = config.name or ""
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.Size = UDim2.new(0.4, 0, 1, 0)
	headerLabel.Position = UDim2.fromOffset(10, 0)
	headerLabel.Parent = header

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = colors.text
	valueLabel.FontFace = Theme.font.medium
	valueLabel.TextSize = Theme.font.body
	valueLabel.Text = tostring(value)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0.55, -24, 1, 0)
	valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
	valueLabel.Parent = header

	local arrow = Instance.new("TextLabel")
	arrow.BackgroundTransparency = 1
	arrow.TextColor3 = colors.textMuted
	arrow.FontFace = Theme.font.regular
	arrow.TextSize = 10
	arrow.Text = "\u{25BE}"
	arrow.Size = UDim2.fromOffset(16, Theme.dim.control)
	arrow.Position = UDim2.new(1, -20, 0, 0)
	arrow.Parent = header

	local optionsList = Instance.new("Frame")
	optionsList.Name = "Options"
	optionsList.BackgroundColor3 = colors.elevated
	optionsList.BorderSizePixel = 0
	optionsList.AutomaticSize = Enum.AutomaticSize.Y
	optionsList.Size = UDim2.new(1, 0, 0, 0)
	optionsList.ClipsDescendants = true
	optionsList.Visible = false
	optionsList.LayoutOrder = 2
	optionsList.Parent = container
	corner(optionsList, Theme.dim.cornerSmall)
	stroke(optionsList, colors.border, 1, 0.5)
	list(optionsList, nil, 0)
	pad(optionsList, 4, 4, 4, 4)

	local function refreshOptions()
		for _, child in optionsList:GetChildren() do
			if child:IsA("TextButton") then
				child.TextColor3 = child.Text == tostring(value) and colors.accent or colors.text
			end
		end
	end

	for i, opt in ipairs(config.options) do
		local btn = Instance.new("TextButton")
		btn.Name = "Opt_" .. tostring(opt)
		btn.Text = tostring(opt)
		btn.TextColor3 = opt == value and colors.accent or colors.text
		btn.FontFace = Theme.font.regular
		btn.TextSize = Theme.font.body
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.BackgroundTransparency = 1
		btn.BackgroundColor3 = colors.hover
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = false
		btn.Size = UDim2.new(1, 0, 0, 28)
		btn.LayoutOrder = i
		btn.Parent = optionsList
		corner(btn, 6)
		pad(btn, 0, 8, 0, 8)

		trove:Connect(btn.MouseEnter, function()
			tween(btn, { BackgroundTransparency = 0 })
		end)
		trove:Connect(btn.MouseLeave, function()
			tween(btn, { BackgroundTransparency = 1 })
		end)

		trove:Connect(btn.MouseButton1Click, function()
			value = opt
			valueLabel.Text = tostring(opt)
			expanded = false
			optionsList.Visible = false
			arrow.Text = "\u{25BE}"
			refreshOptions()
			changed:Fire(value)
			if config.callback then config.callback(value) end
		end)
	end

	trove:Connect(header.MouseButton1Click, function()
		expanded = not expanded
		optionsList.Visible = expanded
		arrow.Text = expanded and "\u{25B4}" or "\u{25BE}"
	end)

	trove:Add(container)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(v)
		value = v
		valueLabel.Text = tostring(v)
		refreshOptions()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end
	function ctrl:Get() return value end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createButton(config, parent)
	local trove = Trove.new()
	local colors = Theme.colors

	local btn = Instance.new("TextButton")
	btn.Name = "Button_" .. (config.name or "")
	btn.Text = config.name or ""
	btn.TextColor3 = colors.text
	btn.FontFace = Theme.font.medium
	btn.TextSize = Theme.font.body
	btn.BackgroundColor3 = colors.elevated
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	btn.Parent = parent
	corner(btn, Theme.dim.cornerSmall)
	stroke(btn, colors.border, 1, 0.5)
	gradient(btn, 90)

	trove:Connect(btn.MouseEnter, function()
		tween(btn, { BackgroundColor3 = colors.hover })
	end)
	trove:Connect(btn.MouseLeave, function()
		tween(btn, { BackgroundColor3 = colors.elevated })
	end)
	trove:Connect(btn.MouseButton1Click, function()
		if config.callback then config.callback() end
	end)

	trove:Add(btn)

	local ctrl = {}
	function ctrl:SetText(t) btn.Text = t end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createLabel(config, parent)
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.BackgroundTransparency = 1
	label.TextColor3 = Theme.colors.textSub
	label.FontFace = Theme.font.regular
	label.TextSize = Theme.font.small
	label.Text = config.text or ""
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.new(1, 0, 0, 18)
	label.Parent = parent

	local ctrl = {}
	function ctrl:Set(t) label.Text = t end
	function ctrl:Get() return label.Text end
	function ctrl:Destroy() label:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createKeybind(config, parent)
	local trove = Trove.new()
	local value = config.default or Enum.KeyCode.Unknown
	local listening = false
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local row = Instance.new("Frame")
	row.Name = "Keybind_" .. (config.name or "")
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = colors.text
	label.FontFace = Theme.font.regular
	label.TextSize = Theme.font.body
	label.Text = config.name or ""
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Parent = row

	local keyBtn = Instance.new("TextButton")
	keyBtn.Text = value.Name
	keyBtn.TextColor3 = colors.accent
	keyBtn.FontFace = Theme.font.medium
	keyBtn.TextSize = Theme.font.small
	keyBtn.BackgroundColor3 = colors.elevated
	keyBtn.BorderSizePixel = 0
	keyBtn.AutoButtonColor = false
	keyBtn.Size = UDim2.fromOffset(60, 24)
	keyBtn.Position = UDim2.new(1, -64, 0.5, -12)
	keyBtn.Parent = row
	corner(keyBtn, 6)
	stroke(keyBtn, colors.border, 1, 0.5)

	trove:Connect(keyBtn.MouseButton1Click, function()
		if listening then return end
		listening = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = colors.textMuted

		local conn
		conn = UIS.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			conn:Disconnect()
			listening = false

			if input.KeyCode == Enum.KeyCode.Escape then
				keyBtn.Text = value.Name
				keyBtn.TextColor3 = colors.accent
				return
			end

			value = input.KeyCode
			keyBtn.Text = value.Name
			keyBtn.TextColor3 = colors.accent
			changed:Fire(value)
			if config.callback then config.callback(value) end
		end)
		trove:Add(conn)
	end)

	trove:Add(row)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(v)
		value = v
		keyBtn.Text = v.Name
	end
	function ctrl:Get() return value end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createTextInput(config, parent)
	local trove = Trove.new()
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local container = Instance.new("Frame")
	container.Name = "TextInput_" .. (config.name or "")
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.Parent = parent
	list(container, nil, 3)

	if config.name then
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.TextColor3 = colors.textSub
		label.FontFace = Theme.font.regular
		label.TextSize = Theme.font.small
		label.Text = config.name
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Size = UDim2.new(1, 0, 0, 16)
		label.LayoutOrder = 1
		label.Parent = container
	end

	local box = Instance.new("TextBox")
	box.PlaceholderText = config.placeholder or ""
	box.PlaceholderColor3 = colors.textMuted
	box.Text = config.default or ""
	box.TextColor3 = colors.text
	box.FontFace = Theme.font.regular
	box.TextSize = Theme.font.body
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.BackgroundColor3 = colors.elevated
	box.BorderSizePixel = 0
	box.ClearTextOnFocus = false
	box.Size = UDim2.new(1, 0, 0, 30)
	box.LayoutOrder = 2
	box.Parent = container
	corner(box, Theme.dim.cornerSmall)
	stroke(box, colors.border, 1, 0.5)
	pad(box, 0, 8, 0, 8)

	local boxStroke = box:FindFirstChildOfClass("UIStroke")

	trove:Connect(box.Focused, function()
		if boxStroke then tween(boxStroke, { Color = colors.accent, Transparency = 0 }) end
	end)
	trove:Connect(box.FocusLost, function()
		if boxStroke then tween(boxStroke, { Color = colors.border, Transparency = 0.5 }) end
		changed:Fire(box.Text)
		if config.callback then config.callback(box.Text) end
	end)

	trove:Add(container)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(t) box.Text = t end
	function ctrl:Get() return box.Text end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createColorPicker(config, parent)
	local trove = Trove.new()
	local h, s, v = Color3.toHSV(config.default or Color3.new(1, 1, 1))
	local value = Color3.fromHSV(h, s, v)
	local expanded = false
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local container = Instance.new("Frame")
	container.Name = "ColorPicker_" .. (config.name or "")
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.ClipsDescendants = false
	container.Parent = parent
	list(container, nil, 4)

	-- Header
	local header = Instance.new("TextButton")
	header.Text = ""
	header.AutoButtonColor = false
	header.BackgroundTransparency = 1
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	header.LayoutOrder = 1
	header.Parent = container

	local headerLabel = Instance.new("TextLabel")
	headerLabel.BackgroundTransparency = 1
	headerLabel.TextColor3 = colors.text
	headerLabel.FontFace = Theme.font.regular
	headerLabel.TextSize = Theme.font.body
	headerLabel.Text = config.name or ""
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.Size = UDim2.new(1, -30, 1, 0)
	headerLabel.Parent = header

	local preview = Instance.new("Frame")
	preview.Name = "Preview"
	preview.BackgroundColor3 = value
	preview.BorderSizePixel = 0
	preview.Size = UDim2.fromOffset(22, 22)
	preview.Position = UDim2.new(1, -26, 0.5, -11)
	preview.Parent = header
	corner(preview, 6)
	stroke(preview, colors.border, 1, 0.3)

	-- Picker panel
	local picker = Instance.new("Frame")
	picker.Name = "Picker"
	picker.BackgroundColor3 = colors.surface
	picker.BorderSizePixel = 0
	picker.AutomaticSize = Enum.AutomaticSize.Y
	picker.Size = UDim2.new(1, 0, 0, 0)
	picker.Visible = false
	picker.LayoutOrder = 2
	picker.Parent = container
	corner(picker, Theme.dim.cornerSmall)
	stroke(picker, colors.border, 1, 0.5)
	pad(picker, 8, 8, 8, 8)
	list(picker, nil, 6)

	-- SV square
	local svSize = 140
	local svFrame = Instance.new("Frame")
	svFrame.Name = "SV"
	svFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	svFrame.BorderSizePixel = 0
	svFrame.Size = UDim2.new(1, 0, 0, svSize)
	svFrame.ClipsDescendants = true
	svFrame.LayoutOrder = 1
	svFrame.Parent = picker
	corner(svFrame, 6)

	local whiteOverlay = Instance.new("Frame")
	whiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
	whiteOverlay.Size = UDim2.fromScale(1, 1)
	whiteOverlay.BorderSizePixel = 0
	whiteOverlay.Parent = svFrame
	local whiteGrad = Instance.new("UIGradient")
	whiteGrad.Transparency = NumberSequence.new(0, 1)
	whiteGrad.Parent = whiteOverlay

	local blackOverlay = Instance.new("Frame")
	blackOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
	blackOverlay.Size = UDim2.fromScale(1, 1)
	blackOverlay.BorderSizePixel = 0
	blackOverlay.ZIndex = 2
	blackOverlay.Parent = svFrame
	local blackGrad = Instance.new("UIGradient")
	blackGrad.Transparency = NumberSequence.new(1, 0)
	blackGrad.Rotation = 90
	blackGrad.Parent = blackOverlay

	local svCursor = Instance.new("Frame")
	svCursor.Name = "Cursor"
	svCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	svCursor.BorderSizePixel = 0
	svCursor.Size = UDim2.fromOffset(10, 10)
	svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	svCursor.ZIndex = 4
	svCursor.Parent = svFrame
	corner(svCursor, 5)
	stroke(svCursor, Color3.new(0, 0, 0), 1, 0.3)

	-- Hue bar
	local hueBar = Instance.new("Frame")
	hueBar.Name = "Hue"
	hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
	hueBar.BorderSizePixel = 0
	hueBar.Size = UDim2.new(1, 0, 0, 14)
	hueBar.ClipsDescendants = true
	hueBar.LayoutOrder = 2
	hueBar.Parent = picker
	corner(hueBar, 4)

	local hueGrad = Instance.new("UIGradient")
	hueGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
		ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
		ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
		ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
		ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
		ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
	})
	hueGrad.Parent = hueBar

	local hueCursor = Instance.new("Frame")
	hueCursor.Name = "HueCursor"
	hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	hueCursor.BorderSizePixel = 0
	hueCursor.Size = UDim2.fromOffset(4, 18)
	hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	hueCursor.Position = UDim2.new(0, 0, 0.5, 0)
	hueCursor.ZIndex = 3
	hueCursor.Parent = hueBar
	corner(hueCursor, 2)
	stroke(hueCursor, Color3.new(0, 0, 0), 1, 0.3)

	local function fireChange()
		value = Color3.fromHSV(h, s, v)
		preview.BackgroundColor3 = value
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end

	local function updateCursors()
		svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
		hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
		svFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	end

	-- SV interaction
	local svDragging = false
	local svBtn = Instance.new("TextButton")
	svBtn.Text = ""
	svBtn.BackgroundTransparency = 1
	svBtn.Size = UDim2.fromScale(1, 1)
	svBtn.ZIndex = 5
	svBtn.AutoButtonColor = false
	svBtn.Parent = svFrame

	local function updateSV(mouse)
		local pos = svFrame.AbsolutePosition
		local sz = svFrame.AbsoluteSize
		s = math.clamp((mouse.X - pos.X) / sz.X, 0, 1)
		v = 1 - math.clamp((mouse.Y - pos.Y) / sz.Y, 0, 1)
		updateCursors()
		fireChange()
	end

	trove:Connect(svBtn.MouseButton1Down, function()
		svDragging = true
		updateSV(getMouse())
	end)

	-- Hue interaction
	local hueDragging = false
	local hueBtn = Instance.new("TextButton")
	hueBtn.Text = ""
	hueBtn.BackgroundTransparency = 1
	hueBtn.Size = UDim2.fromScale(1, 1)
	hueBtn.ZIndex = 5
	hueBtn.AutoButtonColor = false
	hueBtn.Parent = hueBar

	local function updateHue(mouse)
		local pos = hueBar.AbsolutePosition
		local sz = hueBar.AbsoluteSize
		h = math.clamp((mouse.X - pos.X) / sz.X, 0, 0.999)
		updateCursors()
		fireChange()
	end

	trove:Connect(hueBtn.MouseButton1Down, function()
		hueDragging = true
		updateHue(getMouse())
	end)

	trove:Connect(UIS.InputChanged, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		local mouse = getMouse()
		if svDragging then updateSV(mouse) end
		if hueDragging then updateHue(mouse) end
	end)

	trove:Connect(UIS.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			svDragging = false
			hueDragging = false
		end
	end)

	trove:Connect(header.MouseButton1Click, function()
		expanded = not expanded
		picker.Visible = expanded
	end)

	updateCursors()
	trove:Add(container)

	local ctrl = {}
	ctrl.Changed = changed
	function ctrl:Set(c)
		h, s, v = Color3.toHSV(c)
		value = c
		preview.BackgroundColor3 = c
		updateCursors()
	end
	function ctrl:Get() return value end
	function ctrl:Destroy() trove:Destroy() end
	return ctrl
end

----------------------------------------------------------------

local function createExpandableToggle(config, parent)
	local trove = Trove.new()
	local value = config.default or false
	local expanded = false
	local changed = trove:Construct(Signal)
	local colors = Theme.colors

	local container = Instance.new("Frame")
	container.Name = "ExpToggle_" .. (config.name or "")
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.ClipsDescendants = false
	container.Parent = parent
	list(container)

	local header = Instance.new("Frame")
	header.BackgroundTransparency = 1
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, Theme.dim.control)
	header.LayoutOrder = 1
	header.Parent = container

	local arrowBtn = Instance.new("TextButton")
	arrowBtn.Text = "\u{25B8}"
	arrowBtn.TextColor3 = colors.textMuted
	arrowBtn.FontFace = Theme.font.bold
	arrowBtn.TextSize = 11
	arrowBtn.BackgroundTransparency = 1
	arrowBtn.BorderSizePixel = 0
	arrowBtn.AutoButtonColor = false
	arrowBtn.Size = UDim2.fromOffset(18, Theme.dim.control)
	arrowBtn.Parent = header

	local labelBtn = Instance.new("TextButton")
	labelBtn.Text = config.name or ""
	labelBtn.TextColor3 = colors.text
	labelBtn.FontFace = Theme.font.regular
	labelBtn.TextSize = Theme.font.body
	labelBtn.TextXAlignment = Enum.TextXAlignment.Left
	labelBtn.BackgroundTransparency = 1
	labelBtn.BorderSizePixel = 0
	labelBtn.AutoButtonColor = false
	labelBtn.Size = UDim2.new(1, -60, 1, 0)
	labelBtn.Position = UDim2.fromOffset(18, 0)
	labelBtn.Parent = header

	local track = Instance.new("TextButton")
	track.Text = ""
	track.AutoButtonColor = false
	track.BackgroundColor3 = value and colors.accent or colors.toggleOff
	track.BorderSizePixel = 0
	track.Size = UDim2.fromOffset(38, 20)
	track.Position = UDim2.new(1, -42, 0.5, -10)
	track.Parent = header
	corner(track, 10)

	local knob = Instance.new("Frame")
	knob.BackgroundColor3 = value and colors.bg or colors.textSub
	knob.BorderSizePixel = 0
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = value and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
	knob.Parent = track
	corner(knob, 8)

	local content = Instance.new("Frame")
	content.BackgroundColor3 = colors.surface
	content.BorderSizePixel = 0
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Size = UDim2.new(1, 0, 0, 0)
	content.Visible = false
	content.LayoutOrder = 2
	content.Parent = container
	corner(content, 6)
	list(content, nil, Theme.dim.controlGap)
	pad(content, 6, 8, 6, 8)

	local function updateToggle()
		local on = value
		tween(track, { BackgroundColor3 = on and colors.accent or colors.toggleOff })
		tween(knob, {
			Position = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
			BackgroundColor3 = on and colors.bg or colors.textSub,
		})
	end

	local function toggleExpand()
		expanded = not expanded
		content.Visible = expanded
		arrowBtn.Text = expanded and "\u{25BE}" or "\u{25B8}"
	end

	trove:Connect(arrowBtn.MouseButton1Click, toggleExpand)
	trove:Connect(labelBtn.MouseButton1Click, toggleExpand)

	trove:Connect(track.MouseButton1Click, function()
		value = not value
		updateToggle()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end)

	trove:Connect(header.MouseEnter, function()
		labelBtn.TextColor3 = colors.accent
		arrowBtn.TextColor3 = colors.textSub
	end)
	trove:Connect(header.MouseLeave, function()
		labelBtn.TextColor3 = colors.text
		arrowBtn.TextColor3 = colors.textMuted
	end)

	trove:Connect(Theme.Changed, function(key)
		if key == "accent" then updateToggle() end
	end)

	trove:Add(container)

	local subControls = {}
	local ctrl = {}
	ctrl.Changed = changed

	function ctrl:Set(v)
		if v == value then return end
		value = v
		updateToggle()
		changed:Fire(value)
		if config.callback then config.callback(value) end
	end
	function ctrl:Get() return value end

	function ctrl:AddSubToggle(cfg)
		local sub = createToggle(cfg, content)
		table.insert(subControls, sub)
		return sub
	end
	function ctrl:AddSubSlider(cfg)
		local sub = createSlider(cfg, content)
		table.insert(subControls, sub)
		return sub
	end
	function ctrl:AddSubDropdown(cfg)
		local sub = createDropdown(cfg, content)
		table.insert(subControls, sub)
		return sub
	end
	function ctrl:AddSubColorPicker(cfg)
		local sub = createColorPicker(cfg, content)
		table.insert(subControls, sub)
		return sub
	end
	function ctrl:AddSubTextInput(cfg)
		local sub = createTextInput(cfg, content)
		table.insert(subControls, sub)
		return sub
	end

	function ctrl:Destroy()
		for _, sub in subControls do sub:Destroy() end
		trove:Destroy()
	end

	return ctrl
end

--================================================================--
-- CONTROLS TABLE
--================================================================--

local Controls = {
	Toggle = createToggle,
	Slider = createSlider,
	Dropdown = createDropdown,
	Button = createButton,
	Label = createLabel,
	Keybind = createKeybind,
	TextInput = createTextInput,
	ColorPicker = createColorPicker,
	ExpandableToggle = createExpandableToggle,
}

--================================================================--
-- SECTION
--================================================================--

local Section = {}
Section.__index = Section

function Section.new(name, parent)
	local self = setmetatable({}, Section)
	self._controls = {}
	self._nextOrder = 1

	local frame = Instance.new("Frame")
	frame.Name = "Section_" .. name
	frame.BackgroundColor3 = Theme.colors.surface
	frame.BorderSizePixel = 0
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.Parent = parent
	corner(frame, Theme.dim.cornerSmall)
	stroke(frame, Theme.colors.border, 1, 0.6)
	gradient(frame, 90)
	self._frame = frame

	list(frame, nil, Theme.dim.controlGap)
	pad(frame, 8, 10, 10, 10)

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.BackgroundTransparency = 1
	header.TextColor3 = Theme.colors.textMuted
	header.FontFace = Theme.font.bold
	header.TextSize = Theme.font.small
	header.Text = string.upper(name)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Size = UDim2.new(1, 0, 0, 16)
	header.LayoutOrder = -1
	header.Parent = frame
	self._header = header

	return self
end

function Section:_add(controlType, config)
	local factory = Controls[controlType]
	if not factory then error("[Zyx] Unknown control: " .. controlType, 2) end

	local control = factory(config, self._frame)

	for _, child in self._frame:GetChildren() do
		if child:IsA("GuiObject") and child.LayoutOrder == 0 and child ~= self._header then
			child.LayoutOrder = self._nextOrder
		end
	end
	self._nextOrder += 1

	table.insert(self._controls, control)
	return control
end

function Section:AddToggle(c) return self:_add("Toggle", c) end
function Section:AddSlider(c) return self:_add("Slider", c) end
function Section:AddDropdown(c) return self:_add("Dropdown", c) end
function Section:AddButton(c) return self:_add("Button", c) end
function Section:AddLabel(c) return self:_add("Label", c) end
function Section:AddKeybind(c) return self:_add("Keybind", c) end
function Section:AddTextInput(c) return self:_add("TextInput", c) end
function Section:AddColorPicker(c) return self:_add("ColorPicker", c) end
function Section:AddExpandableToggle(c) return self:_add("ExpandableToggle", c) end

function Section:Destroy()
	for _, c in self._controls do c:Destroy() end
	self._frame:Destroy()
end

--================================================================--
-- TAB
--================================================================--

local Tab = {}
Tab.__index = Tab

function Tab.new(name, sidebar, container)
	local self = setmetatable({}, Tab)
	local trove = Trove.new()
	self._trove = trove
	self._sections = {}
	self._name = name
	self._active = false

	local colors = Theme.colors

	self.OnClick = trove:Construct(Signal)

	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = name
	btn.TextColor3 = colors.textSub
	btn.FontFace = Theme.font.medium
	btn.TextSize = Theme.font.body
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BackgroundTransparency = 1
	btn.BackgroundColor3 = colors.surface
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Parent = sidebar
	corner(btn, 6)
	pad(btn, 0, 10, 0, 22)
	self._btn = btn

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.BackgroundColor3 = colors.accent
	indicator.BorderSizePixel = 0
	indicator.Size = UDim2.new(0, 3, 0.6, 0)
	indicator.Position = UDim2.new(0, 4, 0.2, 0)
	indicator.Visible = false
	indicator.Parent = btn
	corner(indicator, 2)
	self._indicator = indicator

	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Size = UDim2.fromScale(1, 1)
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = colors.border
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = container
	self._page = page

	list(page, nil, Theme.dim.sectionGap)
	pad(page, 8, 10, 10, 10)

	trove:Connect(btn.MouseButton1Click, function()
		self.OnClick:Fire()
	end)

	trove:Connect(btn.MouseEnter, function()
		if not self._active then
			tween(btn, { BackgroundTransparency = 0.85 })
			btn.BackgroundColor3 = colors.hover
		end
	end)
	trove:Connect(btn.MouseLeave, function()
		if not self._active then
			tween(btn, { BackgroundTransparency = 1 })
		end
	end)

	trove:Connect(Theme.Changed, function(key)
		if key == "accent" and self._active then
			indicator.BackgroundColor3 = colors.accent
			btn.TextColor3 = colors.accent
		end
	end)

	return self
end

function Tab:Select()
	self._active = true
	self._btn.BackgroundTransparency = 0.88
	self._btn.BackgroundColor3 = Theme.colors.accent
	self._btn.TextColor3 = Theme.colors.accent
	self._indicator.Visible = true
	self._page.Visible = true
end

function Tab:Deselect()
	self._active = false
	self._btn.BackgroundTransparency = 1
	self._btn.BackgroundColor3 = Theme.colors.surface
	self._btn.TextColor3 = Theme.colors.textSub
	self._indicator.Visible = false
	self._page.Visible = false
end

function Tab:AddSection(name)
	local section = Section.new(name, self._page)
	table.insert(self._sections, section)
	return section
end

function Tab:Destroy()
	for _, s in self._sections do s:Destroy() end
	self._trove:Destroy()
end

--================================================================--
-- WINDOW
--================================================================--

local Window = {}
Window.__index = Window

local MIN_W, MIN_H = 440, 320
local MAX_W, MAX_H = 900, 700

function Window.new(config)
	local self = setmetatable({}, Window)
	local trove = Trove.new()
	self._trove = trove
	self._visible = false
	self._cursorConn = nil

	local colors = Theme.colors
	local dim = Theme.dim

	self.Toggled = trove:Construct(Signal)

	local gui = Instance.new("ScreenGui")
	gui.Name = config.title or "ZyxHub"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 999
	if gethui then
		gui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = game:GetService("CoreGui")
	else
		gui.Parent = game:GetService("CoreGui")
	end
	trove:Add(gui)
	self._gui = gui

	-- Root wrapper
	local root = Instance.new("Frame")
	root.Name = "Root"
	root.BackgroundTransparency = 1
	root.BorderSizePixel = 0
	root.Size = UDim2.fromOffset(dim.windowWidth, dim.windowHeight)
	root.Position = UDim2.new(0.5, -dim.windowWidth / 2, 0.5, -dim.windowHeight / 2)
	root.Visible = false
	root.Parent = gui
	self._root = root

	-- Shadow
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.BackgroundColor3 = colors.shadow
	shadow.BackgroundTransparency = 0.75
	shadow.BorderSizePixel = 0
	shadow.Size = UDim2.new(1, 14, 1, 14)
	shadow.Position = UDim2.fromOffset(-5, 4)
	shadow.ZIndex = 1
	shadow.Parent = root
	corner(shadow, dim.corner + 4)

	-- Main
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.BackgroundColor3 = colors.bg
	main.BorderSizePixel = 0
	main.Size = UDim2.fromScale(1, 1)
	main.ClipsDescendants = true
	main.ZIndex = 2
	main.Parent = root
	corner(main)
	stroke(main, colors.border, 1, 0.4)

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.BackgroundColor3 = colors.surface
	titleBar.BorderSizePixel = 0
	titleBar.Size = UDim2.new(1, 0, 0, dim.titleBar)
	titleBar.Parent = main
	gradient(titleBar, 90)

	local titleText = Instance.new("TextLabel")
	titleText.BackgroundTransparency = 1
	titleText.TextColor3 = colors.text
	titleText.FontFace = Theme.font.bold
	titleText.TextSize = Theme.font.title
	titleText.Text = config.title or "Zyx"
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Size = UDim2.new(1, -24, 1, 0)
	titleText.Position = UDim2.fromOffset(14, 0)
	titleText.Parent = titleBar

	local titleSep = Instance.new("Frame")
	titleSep.BackgroundColor3 = colors.border
	titleSep.BackgroundTransparency = 0.5
	titleSep.BorderSizePixel = 0
	titleSep.Size = UDim2.new(1, 0, 0, 1)
	titleSep.Position = UDim2.new(0, 0, 1, -1)
	titleSep.Parent = titleBar

	-- Drag
	do
		local dragging, dragStart, startPos
		trove:Connect(titleBar.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = root.Position
			end
		end)
		trove:Connect(UIS.InputChanged, function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local d = input.Position - dragStart
				root.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + d.X,
					startPos.Y.Scale, startPos.Y.Offset + d.Y
				)
			end
		end)
		trove:Connect(UIS.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end

	-- Body
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Size = UDim2.new(1, 0, 1, -(dim.titleBar + dim.footer))
	body.Position = UDim2.fromOffset(0, dim.titleBar)
	body.Parent = main

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = colors.surface
	sidebar.BorderSizePixel = 0
	sidebar.Size = UDim2.new(0, dim.tabWidth, 1, 0)
	sidebar.Parent = body
	list(sidebar, nil, 2)
	pad(sidebar, 8, 6, 8, 6)
	self._sidebar = sidebar

	local sidebarSep = Instance.new("Frame")
	sidebarSep.BackgroundColor3 = colors.border
	sidebarSep.BackgroundTransparency = 0.5
	sidebarSep.BorderSizePixel = 0
	sidebarSep.Size = UDim2.new(0, 1, 1, 0)
	sidebarSep.Position = UDim2.fromOffset(dim.tabWidth, 0)
	sidebarSep.Parent = body

	-- Content
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Size = UDim2.new(1, -(dim.tabWidth + 1), 1, 0)
	content.Position = UDim2.fromOffset(dim.tabWidth + 1, 0)
	content.Parent = body
	self._container = content

	-- Footer
	local footer = Instance.new("Frame")
	footer.Name = "Footer"
	footer.BackgroundColor3 = colors.surface
	footer.BorderSizePixel = 0
	footer.Size = UDim2.new(1, 0, 0, dim.footer)
	footer.Position = UDim2.new(0, 0, 1, -dim.footer)
	footer.Parent = main

	local footerSep = Instance.new("Frame")
	footerSep.BackgroundColor3 = colors.border
	footerSep.BackgroundTransparency = 0.5
	footerSep.BorderSizePixel = 0
	footerSep.Size = UDim2.new(1, 0, 0, 1)
	footerSep.Parent = footer

	local footerText = Instance.new("TextLabel")
	footerText.BackgroundTransparency = 1
	footerText.TextColor3 = colors.textMuted
	footerText.FontFace = Theme.font.regular
	footerText.TextSize = Theme.font.small - 1
	footerText.Text = "zyx v1.0"
	footerText.TextXAlignment = Enum.TextXAlignment.Left
	footerText.Size = UDim2.new(1, -16, 1, 0)
	footerText.Position = UDim2.fromOffset(10, 0)
	footerText.Parent = footer

	-- Resize handle
	local resizeHandle = Instance.new("TextButton")
	resizeHandle.Text = ""
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.BorderSizePixel = 0
	resizeHandle.AutoButtonColor = false
	resizeHandle.Size = UDim2.fromOffset(18, 18)
	resizeHandle.AnchorPoint = Vector2.new(1, 1)
	resizeHandle.Position = UDim2.new(1, -2, 1, -2)
	resizeHandle.ZIndex = 10
	resizeHandle.Parent = main

	for i = 0, 2 do
		for j = 0, i do
			local dot = Instance.new("Frame")
			dot.BackgroundColor3 = colors.textMuted
			dot.BackgroundTransparency = 0.4
			dot.BorderSizePixel = 0
			dot.Size = UDim2.fromOffset(2, 2)
			dot.Position = UDim2.fromOffset(12 - j * 5, 12 - (i - j) * 5)
			dot.Parent = resizeHandle
			corner(dot, 1)
		end
	end

	do
		local resizing, resizeStart, startSize
		trove:Connect(resizeHandle.MouseButton1Down, function()
			resizing = true
			resizeStart = getMouse()
			startSize = root.AbsoluteSize
		end)
		trove:Connect(UIS.InputChanged, function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mouse = getMouse()
				local dx = mouse.X - resizeStart.X
				local dy = mouse.Y - resizeStart.Y
				local newW = math.clamp(startSize.X + dx, MIN_W, MAX_W)
				local newH = math.clamp(startSize.Y + dy, MIN_H, MAX_H)
				root.Size = UDim2.fromOffset(newW, newH)
			end
		end)
		trove:Connect(UIS.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = false
			end
		end)
	end

	-- Keybind
	if config.keybind then
		trove:Connect(UIS.InputBegan, function(input, processed)
			if processed then return end
			if input.KeyCode == config.keybind then
				self:Toggle()
			end
		end)
	end

	return self
end

function Window:Show()
	self._root.Visible = true
	self._visible = true
	if self._cursorConn then self._cursorConn:Disconnect() end
	self._cursorConn = RunService.RenderStepped:Connect(function()
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		UIS.MouseIconEnabled = true
	end)
	self.Toggled:Fire(true)
end

function Window:Hide()
	self._root.Visible = false
	self._visible = false
	if self._cursorConn then
		self._cursorConn:Disconnect()
		self._cursorConn = nil
	end
	self.Toggled:Fire(false)
end

function Window:Toggle()
	if self._visible then self:Hide() else self:Show() end
end

function Window:IsVisible() return self._visible end
function Window:GetSidebar() return self._sidebar end
function Window:GetContainer() return self._container end

function Window:Destroy()
	if self._cursorConn then self._cursorConn:Disconnect() end
	self._trove:Destroy()
end

--================================================================--
-- HUB
--================================================================--

local Hub = {}
Hub.__index = Hub

function Hub.new(config)
	config = config or {}
	if config.accent then
		Theme.colors.accent = config.accent
	end

	local self = setmetatable({}, Hub)
	self._tabs = {}
	self._activeTab = nil

	self._window = Window.new({
		title = config.title or "Zyx",
		keybind = config.keybind,
	})

	return self
end

function Hub:AddTab(name)
	local tab = Tab.new(
		name,
		self._window:GetSidebar(),
		self._window:GetContainer()
	)

	tab.OnClick:Connect(function()
		self:SelectTab(tab)
	end)

	table.insert(self._tabs, tab)
	if #self._tabs == 1 then
		self:SelectTab(tab)
	end

	return tab
end

function Hub:SelectTab(tab)
	if self._activeTab == tab then return end
	if self._activeTab then self._activeTab:Deselect() end
	self._activeTab = tab
	tab:Select()
end

function Hub:Show() self._window:Show() end
function Hub:Hide() self._window:Hide() end
function Hub:Toggle() self._window:Toggle() end
function Hub:IsVisible() return self._window:IsVisible() end

function Hub:Destroy()
	for _, tab in self._tabs do tab:Destroy() end
	self._window:Destroy()
end

Hub.Theme = Theme
return Hub
