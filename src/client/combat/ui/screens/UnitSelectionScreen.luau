local module = {}

local PrimaryButton = require(script.Parent.Parent.Parent.Parent.assets.components.buttons.PrimaryButton)

export type screen = typeof(module.build())

local SELECT_BUTTON_SIZE = UDim2.fromOffset(132, 40)
local SELECT_BUTTON_COLOR = Color3.fromRGB(88, 158, 255)

function module.build(root: Instance)
    local frame = Instance.new("Frame")
    frame.Name = "UnitSelectionScreen"
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = root

    local selectButton = PrimaryButton.create({
        name = "SelectButton",
        text = "Select",
        size = SELECT_BUTTON_SIZE,
        backgroundColor = SELECT_BUTTON_COLOR,
    })
    selectButton.Parent = frame

    return {
        frame = frame,
        selectButton = selectButton
    }
end

return module