local module = {}

export type PrimaryButtonProps = {
    name: string?,
    size: UDim2?,
    text: string?,
    backgroundColor: Color3?,
    textColor: Color3?,
    autoButtonColor: boolean?
}

local DEFAULT_COLOR = Color3.fromRGB(59, 130, 246)

local function lighten(color: Color3, amount: number): Color3
    return Color3.new(
        math.min(color.R + amount, 1),
        math.min(color.G + amount, 1),
        math.min(color.B + amount, 1)
    )
end

local function darken(color: Color3, amount: number): Color3
    return Color3.new(
        math.max(color.R - amount, 0),
        math.max(color.G - amount, 0),
        math.max(color.B - amount, 0)
    )
end

function module.create(props: PrimaryButtonProps)
    local baseColor = props.backgroundColor or DEFAULT_COLOR

    local btn = Instance.new("TextButton")
    btn.Name = props.name or "PrimaryButton"
    btn.Size = props.size or UDim2.fromOffset(200, 48)
    btn.Text = props.text or "Button"
    btn.BackgroundColor3 = baseColor
    btn.TextColor3 = props.textColor or Color3.new(1, 1, 1)
    btn.AutoButtonColor = if props.autoButtonColor == nil then true else props.autoButtonColor
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, lighten(baseColor, 0.12)),
        ColorSequenceKeypoint.new(1, darken(baseColor, 0.08)),
    })
    gradient.Rotation = 90
    gradient.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Transparency = 0.82
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    return btn
end

function module.setBackgroundColor(btn: TextButton, baseColor: Color3)
    btn.BackgroundColor3 = baseColor

    local gradient = btn:FindFirstChildOfClass("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, lighten(baseColor, 0.12)),
            ColorSequenceKeypoint.new(1, darken(baseColor, 0.08)),
        })
    end
end

function module.setSelected(btn: TextButton, isSelected: boolean)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not stroke then
        return
    end

    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = if isSelected then 2.5 else 1
    stroke.Transparency = if isSelected then 0 else 0.82
end

return module


