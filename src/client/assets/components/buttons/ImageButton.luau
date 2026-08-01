local module = {}

export type ImageButtonProps = {
    name: string?,
    size: UDim2?,
    imageId: string,
    backgroundColor: Color3?,
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

function module.create(props: ImageButtonProps)
    local baseColor = props.backgroundColor or DEFAULT_COLOR
    local shadowColor = darken(baseColor, 0.2)

    local btn = Instance.new("ImageButton")
    btn.Name = props.name or "ImageButton"
    btn.Size = props.size or UDim2.fromOffset(200, 200)
    btn.Image = props.imageId
    btn.BackgroundColor3 = baseColor
    btn.AutoButtonColor = if props.autoButtonColor == nil then true else props.autoButtonColor
    btn.BorderSizePixel = 0
    btn.ScaleType = Enum.ScaleType.Fit

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    -- Shadow effect (top shadow)
    local shadow = Instance.new("UIStroke")
    shadow.Color = shadowColor
    shadow.Transparency = 0.3
    shadow.Thickness = 5
    shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    shadow.LineJoinMode = Enum.LineJoinMode.Round
    shadow.Parent = btn

    -- Hover animation
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = darken(baseColor, 0.1)
        shadow.Transparency = 0.1
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = baseColor
        shadow.Transparency = 0.3
    end)

    -- Click animation
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = darken(baseColor, 0.2)
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = darken(baseColor, 0.1)
    end)

    return btn
end

function module.setBackgroundColor(btn: ImageButton, baseColor: Color3)
    btn.BackgroundColor3 = baseColor
    local shadow = btn:FindFirstChildOfClass("UIStroke")
    if shadow then
        shadow.Color = darken(baseColor, 0.2)
    end
end

return module