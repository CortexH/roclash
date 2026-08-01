local module = {}

export type ActionButtonProps = {
	name: string?,
	size: UDim2?,
	iconId: string,
	title: string?,
	subtitle: string?,
	borderColor: Color3?,
	accentColor: Color3?,
	autoButtonColor: boolean?,
	iconTint: boolean?,
	backgroundTransparency: number?
}

local OUTER_GLOW_IDS = {
	"rbxassetid://99960560837458",
	"rbxassetid://96379297412178",
	"rbxassetid://84233515475790",
}

local DEFAULT_COLOR = Color3.fromRGB(59, 130, 246)
local DEFAULT_BACKGROUND = Color3.fromRGB(30, 30, 30)
local DEFAULT_TEXT_COLOR = Color3.fromRGB(240, 240, 240)
local DEFAULT_SUBTEXT_COLOR = Color3.fromRGB(180, 180, 180)

local function darken(color: Color3, amount: number): Color3
	return Color3.new(
		math.max(color.R - amount, 0),
		math.max(color.G - amount, 0),
		math.max(color.B - amount, 0)
	)
end

local function lighten(color: Color3, amount: number): Color3
	return Color3.new(
		math.min(color.R + amount, 1),
		math.min(color.G + amount, 1),
		math.min(color.B + amount, 1)
	)
end

function module.create(props: ActionButtonProps)
	local primaryColor = props.primaryColor or DEFAULT_COLOR

	-- Main button
	local btn = Instance.new("ImageButton")
	btn.Name = props.name or "ActionButton"
	btn.Size = props.size or UDim2.fromOffset(100, 100)
	btn.BackgroundColor3 = DEFAULT_BACKGROUND
	btn.BackgroundTransparency = 0.2
	btn.AutoButtonColor = if props.autoButtonColor == nil then true else props.autoButtonColor

	-- Main border
	local border = Instance.new("UIStroke")
	border.Color = props.borderColor
	border.Thickness = 1.2
	border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	border.LineJoinMode = Enum.LineJoinMode.Round
	border.Parent = btn

	-- Inner highlight
	local highlight = Instance.new("UIStroke")
	highlight.Color = lighten(props.borderColor, 0.2)
	highlight.Thickness = 0.8
	highlight.Transparency = 0.7
	highlight.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	highlight.LineJoinMode = Enum.LineJoinMode.Round
	highlight.Parent = btn

	-- Outer glow effect
	local glow = Instance.new("UIStroke")
	glow.Color = props.borderColor
	glow.Thickness = 3
	glow.Transparency = 0.9
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	glow.LineJoinMode = Enum.LineJoinMode.Round
	glow.Parent = btn

	-- Corner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	-- Content container
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.fromScale(1, 1)
	content.BackgroundTransparency = 1
	content.Parent = btn

	-- Main layout
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, math.max(2, 4 * (btn.Size.Y.Offset / 100)))
	listLayout.Parent = content

	-- Padding
	local padding = Instance.new("UIPadding")
	local basePadding = math.max(6, 12 * (btn.Size.Y.Offset / 100))
	padding.PaddingLeft = UDim.new(0, basePadding)
	padding.PaddingRight = UDim.new(0, basePadding)
	padding.PaddingTop = UDim.new(0, basePadding)
	padding.PaddingBottom = UDim.new(0, basePadding)
	padding.Parent = content

	-- Icon container with dynamic sizing
	local iconContainer = Instance.new("Frame")
	iconContainer.Name = "IconContainer"
	iconContainer.BackgroundTransparency = 1
	iconContainer.LayoutOrder = 1

	-- Calculate icon size based on text presence
	local iconHeightScale = if props.subtitle then 0.55
		elseif props.title then 0.7
		else 1

	iconContainer.Size = UDim2.new(1, 0, iconHeightScale, 0)
	iconContainer.Parent = content

	-- Glow container
	local glowContainer = Instance.new("Frame")
	glowContainer.Name = "GlowContainer"
	glowContainer.Size = UDim2.fromScale(1, 1)
	glowContainer.BackgroundTransparency = 1
	glowContainer.ZIndex = 1
	glowContainer.Parent = iconContainer

	-- Glow layers
	local glow1 = Instance.new("ImageLabel")
	glow1.Name = "Glow1"
	glow1.Size = UDim2.fromScale(1.1, 1.1)
	glow1.Position = UDim2.fromScale(0.5, 0.5)
	glow1.AnchorPoint = Vector2.new(0.5, 0.5)
	glow1.BackgroundTransparency = 1
	glow1.ImageTransparency = 0.8
	glow1.ScaleType = Enum.ScaleType.Fit
	glow1.ZIndex = 1
	Instance.new("UIAspectRatioConstraint", glow1)
	glow1.Parent = glowContainer

	local glow2 = Instance.new("ImageLabel")
	glow2.Name = "Glow2"
	glow2.Size = UDim2.fromScale(1.35, 1.35)
	glow2.Position = UDim2.fromScale(0.5, 0.5)
	glow2.AnchorPoint = Vector2.new(0.5, 0.5)
	glow2.BackgroundTransparency = 1
	glow2.ImageTransparency = 0.85
	glow2.ScaleType = Enum.ScaleType.Fit
	glow2.ZIndex = 2
	Instance.new("UIAspectRatioConstraint", glow2)
	glow2.Parent = glowContainer

	local glow3 = Instance.new("ImageLabel")
	glow3.Name = "Glow3"
	glow3.Size = UDim2.fromScale(1.8, 1.8)
	glow3.Position = UDim2.fromScale(0.5, 0.5)
	glow3.AnchorPoint = Vector2.new(0.5, 0.5)
	glow3.BackgroundTransparency = 1
	glow3.ImageTransparency = 0
	glow3.ScaleType = Enum.ScaleType.Fit
	glow3.ZIndex = 1
	Instance.new("UIAspectRatioConstraint", glow3)
	glow3.Parent = glowContainer

	-- Outer glow effect (behind icon)
	local outerGlow = Instance.new("ImageLabel")
	outerGlow.Name = "OuterGlow"
	outerGlow.Size = UDim2.fromScale(3, 3)
	outerGlow.Position = UDim2.fromScale(0.5, 0.5)
	outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	outerGlow.Image = "rbxassetid://84233515475790"
	outerGlow.BackgroundTransparency = 1
	outerGlow.ImageColor3 = props.accentColor
	outerGlow.ImageTransparency = 0.4
	outerGlow.ScaleType = Enum.ScaleType.Fit
	outerGlow.ZIndex = 1

	local glowAspectRatio = Instance.new("UIAspectRatioConstraint")
	glowAspectRatio.Parent = outerGlow

	outerGlow.Parent = iconContainer

	-- Icon with aspect ratio constraint
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.fromScale(0.8, 0.8)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Image = props.iconId
	icon.BackgroundTransparency = 1
	icon.ScaleType = Enum.ScaleType.Fit
	icon.ZIndex = 4

	if props.iconTint ~= false then
		icon.ImageColor3 = props.accentColor
	end

	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.Parent = icon

	icon.Parent = iconContainer

	-- Text container with dynamic sizing
	if props.title or props.subtitle then
		local textContainer = Instance.new("Frame")
		textContainer.Name = "TextContainer"
		textContainer.BackgroundTransparency = 1
		textContainer.LayoutOrder = 2

		-- Calculate text container size based on content
		local textHeightScale = if props.subtitle then 0.4
			else 0.25

		textContainer.Size = UDim2.new(1, 0, textHeightScale, 0)
		textContainer.Parent = content

		local textLayout = Instance.new("UIListLayout")
		textLayout.FillDirection = Enum.FillDirection.Vertical
		textLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		textLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		textLayout.SortOrder = Enum.SortOrder.LayoutOrder
		textLayout.Padding = UDim.new(0, math.max(1, 2 * (btn.Size.Y.Offset / 100)))
		textLayout.Parent = textContainer

		if props.title then
			local title = Instance.new("TextLabel")
			title.Name = "Title"
			title.Text = props.title
			title.Font = Enum.Font.GothamBold
			title.TextSize = math.max(11, 14 * (btn.Size.Y.Offset / 100))
			title.TextColor3 = DEFAULT_TEXT_COLOR
			title.BackgroundTransparency = 1
			title.LayoutOrder = 1
			title.Parent = textContainer
			title.AutomaticSize = Enum.AutomaticSize.XY
		end

		if props.subtitle then
			local subtitle = Instance.new("TextLabel")
			subtitle.Name = "Subtitle"
			subtitle.Text = props.subtitle
			subtitle.Font = Enum.Font.GothamMedium
			subtitle.TextSize = math.max(9, 12 * (btn.Size.Y.Offset / 100))
			subtitle.TextColor3 = DEFAULT_SUBTEXT_COLOR
			subtitle.BackgroundTransparency = 1
			subtitle.LayoutOrder = 2
			subtitle.Parent = textContainer
			subtitle.AutomaticSize = Enum.AutomaticSize.XY
		end
	end

	-- States
	local function setState(state: string)
		if state == "Normal" then
			border.Transparency = 0.2
			highlight.Transparency = 0.7
			glow.Transparency = 0.9
			btn.BackgroundTransparency = if props.backgroundTransparency ~= nil then props.backgroundTransparency else 0.2
		elseif state == "Hover" then
			border.Transparency = 0
			highlight.Transparency = 0.5
			glow.Transparency = 0.8
			btn.BackgroundTransparency = 0.1
		elseif state == "Pressed" then
			border.Transparency = 0
			highlight.Transparency = 0.3
			glow.Transparency = 0.7
			btn.BackgroundTransparency = 0.3
		elseif state == "Disabled" then
			border.Transparency = 0.5
			highlight.Transparency = 0.9
			glow.Transparency = 0.95
			btn.BackgroundTransparency = 0.5
		elseif state == "Selected" then
			border.Transparency = 0
			highlight.Transparency = 0.2
			glow.Transparency = 0.7
			border.Thickness = 1.8
			highlight.Thickness = 1
			glow.Thickness = 4
			btn.BackgroundTransparency = 0
		end
	end

	-- Interactions
	btn.MouseEnter:Connect(function()
		setState("Hover")
	end)

	btn.MouseLeave:Connect(function()
		setState("Normal")
	end)

	btn.Activated:Connect(function()
		setState("Pressed")
		task.wait(0.1)
		setState("Hover")
	end)

	-- Initialize
	setState("Normal")

	return btn
end

function module.setSelected(btn: ImageButton, isSelected: boolean)
	local border = btn:FindFirstChildOfClass("UIStroke")
	if not border then
		return
	end

	local highlight = border:FindNextSiblingOfClass("UIStroke")
	local glow = highlight and highlight:FindNextSiblingOfClass("UIStroke")

	if isSelected then
		border.Transparency = 0
		border.Thickness = 1.8
		if highlight then
			highlight.Transparency = 0.2
			highlight.Thickness = 1
		end
		if glow then
			glow.Transparency = 0.7
			glow.Thickness = 4
		end
	else
		border.Transparency = 0.2
		border.Thickness = 1.2
		if highlight then
			highlight.Transparency = 0.7
			highlight.Thickness = 0.8
		end
		if glow then
			glow.Transparency = 0.9
			glow.Thickness = 3
		end
	end
end

return module