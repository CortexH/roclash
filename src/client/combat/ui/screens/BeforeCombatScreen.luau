local module = {}

local PrimaryButton = require(script.Parent.Parent.Parent.Parent.assets.components.buttons.PrimaryButton)

export type screen = typeof(module.build())

function module.build(root)

    local frame = Instance.new("Frame")
    frame.Name = "BeforeCombatScreen"
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = root

    local startButton = PrimaryButton.create({
        name = "StartButton",
        text = "Start Battle",
        size = UDim2.new(0.22, 0, 0, 48),
    })
    startButton.AnchorPoint = Vector2.new(0.5, 0.5)
    startButton.Position = UDim2.fromScale(0.5, 0.8)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(160, 44)
    sizeConstraint.MaxSize = Vector2.new(320, 56)
    sizeConstraint.Parent = startButton

    local textSizeConstraint = Instance.new("UITextSizeConstraint")
    textSizeConstraint.MinTextSize = 14
    textSizeConstraint.MaxTextSize = 22
    textSizeConstraint.Parent = startButton

    startButton.Parent = frame

    return {
        frame = frame,
        startButton = startButton
    }

end

return module