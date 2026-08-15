local module = {}

export type ProgressBarProps = {
	name: string?,
	size: UDim2?,
	value: number?,
	fillColor: Color3?,
	backgroundColor: Color3?,
}

local DEFAULT_FILL_COLOR = Color3.fromRGB(222, 55, 68)
local DEFAULT_BACKGROUND_COLOR = Color3.fromRGB(54, 40, 44)

function module.create(props: ProgressBarProps): Frame
	local bar = Instance.new("Frame")
	bar.Name = props.name or "ProgressBar"
	bar.Size = props.size or UDim2.new(1, 0, 0, 8)
	bar.BackgroundColor3 = props.backgroundColor or DEFAULT_BACKGROUND_COLOR
	bar.BorderSizePixel = 0
	bar.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(math.clamp(props.value or 0, 0, 1), 1)
	fill.BackgroundColor3 = props.fillColor or DEFAULT_FILL_COLOR
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	return bar
end

function module.setValue(bar: Frame, value: number)
	local fill = bar:FindFirstChild("Fill")
	if fill and fill:IsA("Frame") then
		fill.Size = UDim2.fromScale(math.clamp(value, 0, 1), 1)
	end
end

return module
