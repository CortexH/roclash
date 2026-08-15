local module = {}

export type Relationship = "ALLY" | "ENEMY" | "NEUTRAL"

export type UnitStat = {
	key: string,
	label: string,
	value: number | string,
	iconId: string?,
	iconColor: Color3?,
}

export type UnitCardProps = {
	unitId: string,
	unitName: string?,
	unitType: string?,
	relationship: Relationship?,
	health: number?,
	maxHealth: number?,
	stats: { UnitStat }?,
	canAttack: boolean?,
	canMove: boolean?,
	viewportModel: Model?,
}

export type UnitCard = typeof(module.new({
	unitId = "",
}))

module.__index = module

local CompactActionButton = require(
	script.Parent.Parent.Parent.Parent.assets.components.buttons.CompactActionButton
)
local ProgressBar = require(script.Parent.Parent.Parent.Parent.assets.components.bars.ProgressBar)
local ColoredViewport = require(script.Parent.Parent.Parent.Parent.assets.components.viewports.ColoredViewport)

local CARD_WIDTH = 340
local CARD_PADDING = 12
local CONTENT_WIDTH = CARD_WIDTH - CARD_PADDING * 2
local SECTION_GAP = 10
local VIEWPORT_WIDTH = 96
local VIEWPORT_HEIGHT = 112
local STAT_HEIGHT = 26
local STAT_GAP = 8
local ACTION_HEIGHT = 46
local INFORMATION_PADDING = 7

local BACKGROUND_COLOR = Color3.fromRGB(20, 21, 25)
local BORDER_COLOR = Color3.fromRGB(113, 39, 44)
local TEXT_COLOR = Color3.fromRGB(232, 233, 237)
local MUTED_TEXT_COLOR = Color3.fromRGB(173, 176, 184)
local HEALTH_COLOR = Color3.fromRGB(222, 55, 68)
local MOVE_COLOR = Color3.fromRGB(48, 139, 221)
local ATTACK_COLOR = Color3.fromRGB(214, 48, 58)

local RELATIONSHIP_PRESENTATION: { [Relationship]: { label: string, color: Color3 } } = {
	ALLY = {
		label = "ALIADO",
		color = Color3.fromRGB(67, 174, 133),
	},
	ENEMY = {
		label = "INIMIGO",
		color = Color3.fromRGB(218, 50, 61),
	},
	NEUTRAL = {
		label = "NEUTRO",
		color = Color3.fromRGB(151, 154, 164),
	},
}

local function hasText(value: string?): boolean
	return value ~= nil and value ~= ""
end

local function createBadge(text: string, color: Color3): TextLabel
	local badge = Instance.new("TextLabel")
	badge.AutomaticSize = Enum.AutomaticSize.X
	badge.Size = UDim2.fromOffset(0, 22)
	badge.BackgroundColor3 = Color3.fromRGB(13, 14, 17)
	badge.BorderSizePixel = 0
	badge.Text = text
	badge.TextColor3 = color
	badge.Font = Enum.Font.GothamBold
	badge.TextSize = 12

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 7)
	padding.PaddingRight = UDim.new(0, 7)
	padding.Parent = badge

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = badge

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Transparency = 0.25
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = badge

	return badge
end

local function createHeader(props: UnitCardProps): (Frame, TextButton)
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 26)
	header.BackgroundTransparency = 1

	local items = Instance.new("Frame")
	items.Name = "Identity"
	items.Size = UDim2.new(1, -30, 1, 0)
	items.BackgroundTransparency = 1
	items.Parent = header

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 7)
	layout.Parent = items

	if hasText(props.unitName) then
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "UnitName"
		nameLabel.Size = UDim2.fromOffset(145, 24)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = props.unitName :: string
		nameLabel.TextColor3 = TEXT_COLOR
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 16
		nameLabel.LayoutOrder = 1
		nameLabel.Parent = items
	end

	if hasText(props.unitType) then
		local typeBadge = createBadge(props.unitType :: string, Color3.fromRGB(203, 204, 209))
		typeBadge.Name = "UnitType"
		typeBadge.LayoutOrder = 2
		typeBadge.Parent = items
	end

	local relationship = props.relationship and RELATIONSHIP_PRESENTATION[props.relationship]
	if relationship then
		local relationshipBadge = createBadge(relationship.label, relationship.color)
		relationshipBadge.Name = "Relationship"
		relationshipBadge.LayoutOrder = 3
		relationshipBadge.Parent = items
	end

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.fromOffset(22, 22)
	closeButton.Position = UDim2.new(1, 0, 0.5, 0)
	closeButton.AnchorPoint = Vector2.new(1, 0.5)
	closeButton.BackgroundColor3 = Color3.fromRGB(31, 32, 37)
	closeButton.BackgroundTransparency = 0.25
	closeButton.BorderSizePixel = 0
	closeButton.Text = "X"
	closeButton.TextColor3 = MUTED_TEXT_COLOR
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 12
	closeButton.AutoButtonColor = true
	closeButton.Parent = header

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 5)
	closeCorner.Parent = closeButton

	return header, closeButton
end

local function createStatItem(statData: UnitStat, width: number): Frame
	local item = Instance.new("Frame")
	item.Name = "Stat_" .. statData.key
	item.Size = UDim2.fromOffset(width, STAT_HEIGHT)
	item.BackgroundTransparency = 1

	local textStart = 0
	if statData.iconId then
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.fromOffset(17, 17)
		icon.Position = UDim2.new(0, 0, 0.5, 0)
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.BackgroundTransparency = 1
		icon.Image = statData.iconId
		icon.ImageColor3 = statData.iconColor or MUTED_TEXT_COLOR
		icon.ScaleType = Enum.ScaleType.Fit
		icon.Parent = item
		textStart = 22
	end

	local valueText = tostring(statData.value)
	local valueWidth = math.clamp(#valueText * 8 + 4, 22, 54)

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -(textStart + valueWidth + 5), 1, 0)
	label.Position = UDim2.fromOffset(textStart, 0)
	label.BackgroundTransparency = 1
	label.Text = statData.label
	label.TextColor3 = MUTED_TEXT_COLOR
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamMedium
	label.TextScaled = true
	label.Parent = item

	local labelTextConstraint = Instance.new("UITextSizeConstraint")
	labelTextConstraint.MinTextSize = 11
	labelTextConstraint.MaxTextSize = 13
	labelTextConstraint.Parent = label

	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.fromOffset(valueWidth, STAT_HEIGHT)
	value.Position = UDim2.new(1, 0, 0, 0)
	value.AnchorPoint = Vector2.new(1, 0)
	value.BackgroundTransparency = 1
	value.Text = valueText
	value.TextColor3 = TEXT_COLOR
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Font = Enum.Font.GothamBold
	value.TextSize = 14
	value.Parent = item

	return item
end

local function formatHealth(health: number, maxHealth: number?): string
	if maxHealth ~= nil then
		return tostring(health) .. " / " .. tostring(maxHealth)
	end
	return tostring(health)
end

local function createHealthSection(health: number, maxHealth: number?): (Frame, TextLabel, Frame)
	local section = Instance.new("Frame")
	section.Name = "Health"
	section.Size = UDim2.new(1, 0, 0, 46)
	section.BackgroundTransparency = 1

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.fromOffset(20, 20)
	icon.Position = UDim2.fromOffset(0, 0)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://86333475531597"
	icon.ImageColor3 = Color3.fromRGB(92, 205, 91)
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = section

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromOffset(32, 20)
	label.Position = UDim2.fromOffset(25, 0)
	label.BackgroundTransparency = 1
	label.Text = "HP"
	label.TextColor3 = TEXT_COLOR
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.Parent = section

	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.new(1, -62, 0, 20)
	value.Position = UDim2.fromOffset(62, 0)
	value.BackgroundTransparency = 1
	value.Text = formatHealth(health, maxHealth)
	value.TextColor3 = TEXT_COLOR
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Font = Enum.Font.GothamMedium
	value.TextSize = 14
	value.Parent = section

	local canCalculateRatio = maxHealth ~= nil and maxHealth > 0
	local healthBar = ProgressBar.create({
		name = "HealthBar",
		size = UDim2.new(1, 0, 0, 9),
		value = if canCalculateRatio then health / (maxHealth :: number) else 0,
		fillColor = HEALTH_COLOR,
		backgroundColor = Color3.fromRGB(56, 37, 41),
	})
	healthBar.Position = UDim2.fromOffset(0, 29)
	healthBar.Visible = canCalculateRatio
	healthBar.Parent = section

	return section, value, healthBar
end

function module.new(props: UnitCardProps)
	local self = setmetatable({}, module)
	self.unitId = props.unitId
	self.maxHealth = props.maxHealth

	local frame = Instance.new("Frame")
	frame.Name = "UnitCard"
	frame.Size = UDim2.fromOffset(CARD_WIDTH, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.AnchorPoint = Vector2.new(0, 1)
	frame.BackgroundColor3 = BACKGROUND_COLOR
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = false
	self.frame = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = BORDER_COLOR
	stroke.Transparency = 0.15
	stroke.Thickness = 1.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 0, 0)
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.BackgroundTransparency = 1
	content.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, CARD_PADDING)
	padding.PaddingRight = UDim.new(0, CARD_PADDING)
	padding.PaddingTop = UDim.new(0, CARD_PADDING)
	padding.PaddingBottom = UDim.new(0, CARD_PADDING)
	padding.Parent = content

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Vertical
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, SECTION_GAP)
	contentLayout.Parent = content

	local header, closeButton = createHeader(props)
	header.LayoutOrder = 1
	header.Parent = content
	self.btnFechar = closeButton

	local stats = props.stats or {}
	local hasViewport = props.viewportModel ~= nil
	local hasHealth = props.health ~= nil
	local hasStats = #stats > 0
	local hasInformation = hasHealth or hasStats

	if hasViewport or hasInformation then
		local statsRowCount = math.ceil(#stats / 2)
		local statsHeight = if hasStats
			then statsRowCount * STAT_HEIGHT + math.max(statsRowCount - 1, 0) * STAT_GAP
			else 0
		local informationContentHeight = (if hasHealth then 46 else 0)
			+ (if hasHealth and hasStats then SECTION_GAP else 0)
			+ statsHeight
		local informationHeight = if hasInformation
			then informationContentHeight + INFORMATION_PADDING * 2
			else 0
		local bodyHeight = math.max(if hasViewport then VIEWPORT_HEIGHT else 0, informationHeight)

		local body = Instance.new("Frame")
		body.Name = "Body"
		body.LayoutOrder = 2
		body.Size = UDim2.new(1, 0, 0, bodyHeight)
		body.BackgroundTransparency = 1
		body.Parent = content

		local informationOffset = 0
		if hasViewport then
			local viewport = ColoredViewport.create({
				name = "UnitViewport",
				size = UDim2.fromOffset(VIEWPORT_WIDTH, VIEWPORT_HEIGHT),
				worldModel = props.viewportModel,
				borderColor = Color3.fromRGB(177, 180, 187),
				backgroundColor = Color3.fromRGB(16, 17, 20),
				backgroundTransparency = 0.15,
				cameraDistanceScale = 1.45,
			})
			viewport.Parent = body
			informationOffset = VIEWPORT_WIDTH + 14
		end

		if hasInformation then
			local informationWidth = CONTENT_WIDTH - informationOffset
			local informationPanel = Instance.new("Frame")
			informationPanel.Name = "InformationPanel"
			informationPanel.Size = UDim2.fromOffset(informationWidth, informationHeight)
			informationPanel.Position = UDim2.fromOffset(informationOffset, 0)
			informationPanel.BackgroundTransparency = 1
			informationPanel.Parent = body

			local informationCorner = Instance.new("UICorner")
			informationCorner.CornerRadius = UDim.new(0, 7)
			informationCorner.Parent = informationPanel

			local informationStroke = Instance.new("UIStroke")
			informationStroke.Name = "Border"
			informationStroke.Color = Color3.fromRGB(103, 106, 116)
			informationStroke.Transparency = 0.45
			informationStroke.Thickness = 1
			informationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			informationStroke.Parent = informationPanel

			local information = Instance.new("Frame")
			information.Name = "Information"
			information.Size = UDim2.new(1, -INFORMATION_PADDING * 2, 0, informationContentHeight)
			information.Position = UDim2.fromOffset(INFORMATION_PADDING, INFORMATION_PADDING)
			information.BackgroundTransparency = 1
			information.Parent = informationPanel

			local informationLayout = Instance.new("UIListLayout")
			informationLayout.FillDirection = Enum.FillDirection.Vertical
			informationLayout.SortOrder = Enum.SortOrder.LayoutOrder
			informationLayout.Padding = UDim.new(0, SECTION_GAP)
			informationLayout.Parent = information

			if hasHealth then
				local healthSection, hpValue, healthBar = createHealthSection(
					props.health :: number,
					props.maxHealth
				)
				healthSection.LayoutOrder = 1
				healthSection.Parent = information
				self.hpValue = hpValue
				self.healthBar = healthBar
			end

			if hasStats then
				local statsFrame = Instance.new("Frame")
				statsFrame.Name = "Stats"
				statsFrame.LayoutOrder = 2
				statsFrame.Size = UDim2.new(1, 0, 0, statsHeight)
				statsFrame.BackgroundTransparency = 1
				statsFrame.Parent = information

				local innerInformationWidth = informationWidth - INFORMATION_PADDING * 2
				local cellWidth = math.floor((innerInformationWidth - STAT_GAP) / 2)
				local grid = Instance.new("UIGridLayout")
				grid.CellSize = UDim2.fromOffset(cellWidth, STAT_HEIGHT)
				grid.CellPadding = UDim2.fromOffset(STAT_GAP, STAT_GAP)
				grid.SortOrder = Enum.SortOrder.LayoutOrder
				grid.Parent = statsFrame

				for index, statData in stats do
					local stat = createStatItem(statData, cellWidth)
					stat.LayoutOrder = index
					stat.Parent = statsFrame
				end
			end
		end
	end

	local actionCount = (if props.canMove == true then 1 else 0)
		+ (if props.canAttack == true then 1 else 0)
	if actionCount > 0 then
		local actions = Instance.new("Frame")
		actions.Name = "Actions"
		actions.LayoutOrder = 3
		actions.Size = UDim2.new(1, 0, 0, ACTION_HEIGHT)
		actions.BackgroundTransparency = 1
		actions.Parent = content

		local actionLayout = Instance.new("UIListLayout")
		actionLayout.FillDirection = Enum.FillDirection.Horizontal
		actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		actionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		actionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		actionLayout.Padding = UDim.new(0, 12)
		actionLayout.Parent = actions

		local buttonWidth = math.floor((CONTENT_WIDTH - (actionCount - 1) * 12) / actionCount)

		if props.canMove == true then
			local moveButton = CompactActionButton.create({
				name = "Btn_andar",
				size = UDim2.fromOffset(buttonWidth, ACTION_HEIGHT),
				text = "MOVER",
				iconId = "rbxassetid://114556931652590",
				accentColor = MOVE_COLOR,
			})
			moveButton.LayoutOrder = 1
			moveButton.Parent = actions
			self.btnMover = moveButton
		end

		if props.canAttack == true then
			local attackButton = CompactActionButton.create({
				name = "Btn_atacar",
				size = UDim2.fromOffset(buttonWidth, ACTION_HEIGHT),
				text = "ATACAR",
				iconId = "rbxassetid://100056902946725",
				accentColor = ATTACK_COLOR,
			})
			attackButton.LayoutOrder = 2
			attackButton.Parent = actions
			self.btnAtacar = attackButton
		end
	end

	return self
end

function module:updateHealth(health: number, maxHealth: number?)
	if not self.hpValue then return end
	if maxHealth ~= nil then
		self.maxHealth = maxHealth
	end

	self.hpValue.Text = formatHealth(health, self.maxHealth)
	local canCalculateRatio = self.maxHealth ~= nil and self.maxHealth > 0
	self.healthBar.Visible = canCalculateRatio
	if canCalculateRatio then
		ProgressBar.setValue(self.healthBar, health / self.maxHealth)
	end
end

function module:setActionSelected(moveSelected: boolean, attackSelected: boolean)
	if self.btnMover then
		CompactActionButton.setSelected(self.btnMover, moveSelected)
	end
	if self.btnAtacar then
		CompactActionButton.setSelected(self.btnAtacar, attackSelected)
	end
end

function module:Destroy()
	self.frame:Destroy()
end

return module
