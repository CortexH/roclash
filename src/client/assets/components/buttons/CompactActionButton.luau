local module = {}

export type CompactActionButtonProps = {
	name: string?,
	size: UDim2?,
	text: string,
	iconId: string,
	accentColor: Color3,
}

local BACKGROUND_COLOR = Color3.fromRGB(24, 26, 31)
local TEXT_COLOR = Color3.fromRGB(232, 233, 237)

local function applyVisualState(button: ImageButton, state: string)
	local stroke = button:FindFirstChild("Border")
	if not stroke or not stroke:IsA("UIStroke") then return end

	local isSelected = button:GetAttribute("Selected") == true
	if isSelected then
		button.BackgroundTransparency = 0.05
		stroke.Transparency = 0
		stroke.Thickness = 2
	elseif state == "Hover" then
		button.BackgroundTransparency = 0.08
		stroke.Transparency = 0
		stroke.Thickness = 1.5
	elseif state == "Pressed" then
		button.BackgroundTransparency = 0.2
		stroke.Transparency = 0
		stroke.Thickness = 1.5
	else
		button.BackgroundTransparency = 0.35
		stroke.Transparency = 0.2
		stroke.Thickness = 1.25
	end
end

function module.create(props: CompactActionButtonProps): ImageButton
	local button = Instance.new("ImageButton")
	button.Name = props.name or "CompactActionButton"
	button.Size = props.size or UDim2.fromOffset(148, 46)
	button.BackgroundColor3 = BACKGROUND_COLOR
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Image = ""
	button:SetAttribute("Selected", false)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Name = "Border"
	stroke.Color = props.accentColor
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = button

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.fromScale(1, 1)
	content.BackgroundTransparency = 1
	content.Parent = button

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 8)
	layout.Parent = content

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.fromOffset(25, 25)
	icon.BackgroundTransparency = 1
	icon.Image = props.iconId
	icon.ImageColor3 = props.accentColor
	icon.ScaleType = Enum.ScaleType.Fit
	icon.LayoutOrder = 1
	icon.Parent = content

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Size = UDim2.fromOffset(0, 22)
	label.BackgroundTransparency = 1
	label.Text = props.text
	label.TextColor3 = TEXT_COLOR
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.LayoutOrder = 2
	label.Parent = content

	button.MouseEnter:Connect(function()
		applyVisualState(button, "Hover")
	end)
	button.MouseLeave:Connect(function()
		applyVisualState(button, "Normal")
	end)
	button.MouseButton1Down:Connect(function()
		applyVisualState(button, "Pressed")
	end)
	button.MouseButton1Up:Connect(function()
		applyVisualState(button, "Hover")
	end)

	applyVisualState(button, "Normal")
	return button
end

function module.setSelected(button: ImageButton, isSelected: boolean)
	button:SetAttribute("Selected", isSelected)
	applyVisualState(button, "Normal")
end

return module
