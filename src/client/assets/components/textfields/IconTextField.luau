local module = {}

export type IconTextFieldProps = {
    name: string?,
    size: UDim2?,
    text: string?,
    textColor: Color3?,
    backgroundColor: Color3?,
    imageId: string?,
    imagePosition: "left" | "right"?,
    textAlign: Enum.TextXAlignment?,
    placeholderText: string?,
    placeholderColor: Color3?
}

local DEFAULT_COLOR = Color3.fromRGB(59, 130, 246)
local DEFAULT_TEXT_COLOR = Color3.new(1, 1, 1)
local DEFAULT_PLACEHOLDER_COLOR = Color3.fromRGB(178, 178, 178)

function module.create(props: IconTextFieldProps)
    local frame = Instance.new("Frame")
    frame.Name = props.name or "IconTextField"
    frame.Size = props.size or UDim2.fromOffset(200, 40)
    frame.BackgroundColor3 = props.backgroundColor or DEFAULT_COLOR
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    -- Text field
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextField"
    textBox.Size = UDim2.new(1, 0, 1, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = props.text or ""
    textBox.TextColor3 = props.textColor or DEFAULT_TEXT_COLOR
    textBox.TextXAlignment = props.textAlign or Enum.TextXAlignment.Left
    textBox.PlaceholderText = props.placeholderText or ""
    textBox.PlaceholderColor3 = props.placeholderColor or DEFAULT_PLACEHOLDER_COLOR
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 14
    textBox.Parent = frame

    -- Image icon (if provided)
    if props.imageId then
        local imageSize = frame.Size.Y.Offset - 8  -- Padding interno
        
        local image = Instance.new("ImageLabel")
        image.Name = "Icon"
        image.Size = UDim2.fromOffset(imageSize, imageSize)
        image.Position = UDim2.fromScale(0, 0.5)
        image.AnchorPoint = Vector2.new(0, 0.5)
        image.Image = props.imageId
        image.BackgroundTransparency = 1
        image.Parent = frame

        -- Adjust text box based on image position
        if props.imagePosition == "left" then
            image.Position = UDim2.fromScale(0, 0.5)
            textBox.Position = UDim2.new(0, imageSize + 8, 0, 0)
            textBox.Size = UDim2.new(1, -(imageSize + 8), 1, 0)
        else
            image.Position = UDim2.new(1, 0, 0.5, 0)
            image.AnchorPoint = Vector2.new(1, 0.5)
            textBox.Size = UDim2.new(1, -(imageSize + 8), 1, 0)
        end
    end

    return frame
end

function module.setText(frame: Frame, text: string)
    local textBox = frame:FindFirstChild("TextField")
    if textBox then
        textBox.Text = text
    end
end

function module.setImage(frame: Frame, imageId: string, position: "left" | "right")
    local textBox = frame:FindFirstChild("TextField")
    local existingImage = frame:FindFirstChild("Icon")
    
    if existingImage then
        existingImage:Destroy()
    end
    
    if imageId then
        local imageSize = frame.Size.Y.Offset - 8
        
        local image = Instance.new("ImageLabel")
        image.Name = "Icon"
        image.Size = UDim2.fromOffset(imageSize, imageSize)
        image.Image = imageId
        image.BackgroundTransparency = 1
        image.Parent = frame

        if position == "left" then
            image.Position = UDim2.fromScale(0, 0.5)
            image.AnchorPoint = Vector2.new(0, 0.5)
            textBox.Position = UDim2.new(0, imageSize + 8, 0, 0)
            textBox.Size = UDim2.new(1, -(imageSize + 8), 1, 0)
        else
            image.Position = UDim2.new(1, 0, 0.5, 0)
            image.AnchorPoint = Vector2.new(1, 0.5)
            textBox.Size = UDim2.new(1, -(imageSize + 8), 1, 0)
        end
    else
        -- Reset text box to full width if no image
        textBox.Position = UDim2.fromOffset(0, 0)
        textBox.Size = UDim2.new(1, 0, 1, 0)
    end
end

return module