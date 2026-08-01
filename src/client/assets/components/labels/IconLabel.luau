local module = {}

export type IconLabelProps = {
    name: string?,
    size: UDim2?,
    text: string?,
    textColor: Color3?,
    backgroundColor: Color3?,
    borderColor: Color3?,
    imageId: string?,
    imagePosition: "left" | "right"?,
    textAlign: Enum.TextXAlignment?,
    textTruncate: Enum.TextTruncate?,
    imageScale: number?  -- 1.0 = 100%, 0.8 = 80% etc
}

local DEFAULT_COLOR = Color3.fromRGB(59, 130, 246)
local DEFAULT_TEXT_COLOR = Color3.new(1, 1, 1)

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

local function calculateResponsiveSize(baseSize: number, minSize: number, maxSize: number, frameHeight: number)
    -- Base size is for a 40px tall frame (default size)
    local scale = frameHeight / 40
    local size = baseSize * scale
    return math.clamp(size, minSize, maxSize)
end

local function calculateTextSize(frameHeight: number)
    -- Calculate based on height, then let UITextSizeConstraint handle width constraints
    return calculateResponsiveSize(14, 10, 24, frameHeight)
end

local function calculateComfortablePadding(frameHeight: number)
    -- Base padding is 8px for 40px height, scales proportionally
    return calculateResponsiveSize(8, 6, 16, frameHeight)
end

local function calculateOppositePadding(frameHeight: number, imageSize: number)
    -- Comfortable padding + image size + extra space
    return calculateComfortablePadding(frameHeight) + imageSize + calculateComfortablePadding(frameHeight)
end

local function applyLabelPadding(label: TextLabel, leftPadding: number, rightPadding: number)
    local padding = label:FindFirstChildOfClass("UIPadding")
    if not padding then
        padding = Instance.new("UIPadding")
        padding.Parent = label
    end
    
    padding.PaddingLeft = UDim.new(0, leftPadding)
    padding.PaddingRight = UDim.new(0, rightPadding)
end

function module.create(props: IconLabelProps)
    local baseColor = props.backgroundColor or DEFAULT_COLOR

    local frame = Instance.new("Frame")
    frame.Name = props.name or "IconLabel"
    frame.Size = props.size or UDim2.fromOffset(200, 40)
    frame.BackgroundColor3 = baseColor
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, calculateResponsiveSize(8, 4, 16, frame.Size.Y.Offset))
    corner.Parent = frame

    -- Gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, lighten(baseColor, 0.12)),
        ColorSequenceKeypoint.new(1, darken(baseColor, 0.08)),
    })
    gradient.Rotation = 90
    gradient.Parent = frame

    -- Border
    local stroke = Instance.new("UIStroke")
    stroke.Color = if props.borderColor then props.borderColor else darken(baseColor, 0.2)
    stroke.Transparency = 0.3
    
    -- Responsive stroke thickness
    local strokeThickness = calculateResponsiveSize(1, 1, 3, frame.Size.Y.Offset)
    stroke.Thickness = strokeThickness
    
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.Parent = frame

    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = props.text or ""
    label.TextColor3 = props.textColor or DEFAULT_TEXT_COLOR
    label.TextXAlignment = props.textAlign or Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    
    -- Responsive text size with automatic scaling
    local textSize = calculateTextSize(frame.Size.Y.Offset)
    label.TextSize = textSize
    
    -- Add UITextSizeConstraint to handle width constraints
    local textSizeConstraint = Instance.new("UITextSizeConstraint")
    textSizeConstraint.MinTextSize = 10
    textSizeConstraint.MaxTextSize = 24
    textSizeConstraint.Parent = label
    
    label.TextTruncate = props.textTruncate or Enum.TextTruncate.AtEnd
    
    -- Apply default padding
    applyLabelPadding(label, 8, 8)
    label.Parent = frame

    -- Image icon (if provided)
    if props.imageId then
        local imageSize = (frame.Size.Y.Offset - 8) * (props.imageScale or 1.0)
        
        local image = Instance.new("ImageLabel")
        image.Name = "Icon"
        image.Size = UDim2.fromOffset(imageSize, imageSize)
        image.Position = UDim2.fromScale(0, 0.5)
        image.AnchorPoint = Vector2.new(0, 0.5)
        image.Image = props.imageId
        image.BackgroundTransparency = 1
        image.Parent = frame

        -- Position image and adjust label padding with comfortable spacing
        local comfortablePadding = calculateComfortablePadding(frame.Size.Y.Offset)
        
        if props.imagePosition == "left" then
            image.Position = UDim2.new(0, comfortablePadding, 0.5, 0)
            image.AnchorPoint = Vector2.new(0, 0.5)
            
            -- More padding on opposite side when icon is present
            local oppositePadding = calculateOppositePadding(frame.Size.Y.Offset, imageSize)
            applyLabelPadding(label, imageSize + comfortablePadding * 1.5, comfortablePadding)
        else
            image.Position = UDim2.new(1, -comfortablePadding, 0.5, 0)
            image.AnchorPoint = Vector2.new(1, 0.5)
            
            -- More padding on opposite side when icon is present
            local oppositePadding = calculateOppositePadding(frame.Size.Y.Offset, imageSize)
            applyLabelPadding(label, comfortablePadding, imageSize + comfortablePadding * 1.5)
        end
    end

    return frame
end

function module.setBackgroundColor(frame: Frame, baseColor: Color3)
    frame.BackgroundColor3 = baseColor

    local gradient = frame:FindFirstChildOfClass("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, lighten(baseColor, 0.12)),
            ColorSequenceKeypoint.new(1, darken(baseColor, 0.08)),
        })
    end

    local stroke = frame:FindFirstChildOfClass("UIStroke")
    if stroke then
        -- Only update color if not using custom border color
        if not stroke:GetAttribute("CustomBorderColor") then
            stroke.Color = darken(baseColor, 0.2)
        end
        
        -- Update stroke thickness when color changes (in case frame was resized)
        stroke.Thickness = calculateResponsiveSize(1, 1, 3, frame.Size.Y.Offset)
    end
    
    -- Update corner radius when color changes (in case frame was resized)
    local corner = frame:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(0, calculateResponsiveSize(8, 4, 16, frame.Size.Y.Offset))
    end
    
    -- Update text size when color changes (in case frame was resized)
    local label = frame:FindFirstChild("Label")
    if label then
        local textSizeConstraint = label:FindFirstChildOfClass("UITextSizeConstraint")
        if not textSizeConstraint then
            textSizeConstraint = Instance.new("UITextSizeConstraint")
            textSizeConstraint.MinTextSize = 10
            textSizeConstraint.MaxTextSize = 24
            textSizeConstraint.Parent = label
        end
        
        label.TextSize = calculateResponsiveSize(14, 10, 24, frame.Size.Y.Offset)
    end
end

function module.setBorderColor(frame: Frame, color: Color3?)
    local stroke = frame:FindFirstChildOfClass("UIStroke")
    if stroke then
        if color then
            stroke.Color = color
            stroke:SetAttribute("CustomBorderColor", true)
        else
            stroke.Color = darken(frame.BackgroundColor3, 0.2)
            stroke:SetAttribute("CustomBorderColor", nil)
        end
    end
end

function module.setText(frame: Frame, text: string)
    local label = frame:FindFirstChild("Label")
    if label then
        label.Text = text
    end
end

function module.setImage(frame: Frame, imageId: string, position: "left" | "right", scale: number?)
    local label = frame:FindFirstChild("Label")
    local existingImage = frame:FindFirstChild("Icon")
    
    if existingImage then
        existingImage:Destroy()
    end
    
    if imageId then
        local imageSize = (frame.Size.Y.Offset - 8) * (scale or 1.0)
        
        local image = Instance.new("ImageLabel")
        image.Name = "Icon"
        image.Size = UDim2.fromOffset(imageSize, imageSize)
        image.Image = imageId
        image.BackgroundTransparency = 1
        image.Parent = frame

        local comfortablePadding = calculateComfortablePadding(frame.Size.Y.Offset)
        
        if position == "left" then
            image.Position = UDim2.new(0, comfortablePadding, 0.5, 0)
            image.AnchorPoint = Vector2.new(0, 0.5)
            
            -- More padding on opposite side when icon is present
            local oppositePadding = calculateOppositePadding(frame.Size.Y.Offset, imageSize)
            applyLabelPadding(label, imageSize + comfortablePadding * 1.5, comfortablePadding)
        else
            image.Position = UDim2.new(1, -comfortablePadding, 0.5, 0)
            image.AnchorPoint = Vector2.new(1, 0.5)
            
            -- More padding on opposite side when icon is present
            local oppositePadding = calculateOppositePadding(frame.Size.Y.Offset, imageSize)
            applyLabelPadding(label, comfortablePadding, imageSize + comfortablePadding * 1.5)
        end
        
        -- Restore original text alignment from frame
        local frameLabel = frame:FindFirstChild("Label")
        if frameLabel then
            label.TextXAlignment = frameLabel.TextXAlignment
        end
    else
        -- Reset label to default padding if no image
        applyLabelPadding(label, 8, 8)
    end
end

return module
