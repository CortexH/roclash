local module = {}

local PrimaryButton = require(script.Parent.Parent.Parent.Parent.assets.components.buttons.PrimaryButton)
local UnitCard = require(script.Parent.Parent.components.UnitCard)

export type Behavior = "PEACEFUL" | "DEFENSIVE" | "AGGRESSIVE"
export type screen = typeof(module.build())

local BEHAVIOR_BUTTON_SIZE = UDim2.fromOffset(132, 40)
local SELECT_BUTTON_SIZE = UDim2.fromOffset(132, 40)
local PLACE_UNIT_COLOR = Color3.fromRGB(88, 158, 255)
local SELECT_BUTTON_COLOR = Color3.fromRGB(120, 180, 100)

local BEHAVIOR_COLORS: { [Behavior]: Color3 } = {
    PEACEFUL = Color3.fromRGB(56, 168, 128),
    DEFENSIVE = Color3.fromRGB(78, 138, 220),
    AGGRESSIVE = Color3.fromRGB(220, 92, 78),
}

local function applyButtonConstraints(button: TextButton, minSize: Vector2, maxSize: Vector2, maxTextSize: number?)
    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = minSize
    sizeConstraint.MaxSize = maxSize
    sizeConstraint.Parent = button

    local textSizeConstraint = Instance.new("UITextSizeConstraint")
    textSizeConstraint.MinTextSize = 12
    textSizeConstraint.MaxTextSize = maxTextSize or 18
    textSizeConstraint.Parent = button
end

local function createBehaviorButton(name: string, text: string, layoutOrder: number, color: Color3)
    local button = PrimaryButton.create({
        name = name,
        text = text,
        size = BEHAVIOR_BUTTON_SIZE,
        backgroundColor = color,
        autoButtonColor = false,
    })
    button.LayoutOrder = layoutOrder
    applyButtonConstraints(button, Vector2.new(108, 36), Vector2.new(160, 44), 16)
    return button
end

function module.build(root)
    local frame = Instance.new("Frame")
    frame.Name = "BattleHudScreen"
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = root

    -- Main controls frame
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "MainControls"
    controlsFrame.Size = UDim2.fromOffset(460, 0)
    controlsFrame.AutomaticSize = Enum.AutomaticSize.Y
    controlsFrame.AnchorPoint = Vector2.new(0.5, 1)
    controlsFrame.Position = UDim2.new(0.5, 0, 1, -28)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = frame

    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Vertical
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Padding = UDim.new(0, 10)
    controlsLayout.Parent = controlsFrame

    -- Behavior panel
    local behaviorContainer = Instance.new("Frame")
    behaviorContainer.Name = "BehaviorContainer"
    behaviorContainer.LayoutOrder = 1
    behaviorContainer.Size = UDim2.fromOffset(460, 40)
    behaviorContainer.BackgroundTransparency = 1
    behaviorContainer.Visible = false
    behaviorContainer.Parent = controlsFrame

    local behaviorLayout = Instance.new("UIListLayout")
    behaviorLayout.FillDirection = Enum.FillDirection.Horizontal
    behaviorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    behaviorLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    behaviorLayout.Padding = UDim.new(0, 8)
    behaviorLayout.Parent = behaviorContainer

    local peacefulButton = createBehaviorButton("PeacefulButton", "Peaceful", 1, BEHAVIOR_COLORS.PEACEFUL)
    peacefulButton.Parent = behaviorContainer

    local defensiveButton = createBehaviorButton("DefensiveButton", "Defensive", 2, BEHAVIOR_COLORS.DEFENSIVE)
    defensiveButton.Parent = behaviorContainer

    local aggressiveButton = createBehaviorButton("AggressiveButton", "Aggressive", 3, BEHAVIOR_COLORS.AGGRESSIVE)
    aggressiveButton.Parent = behaviorContainer

    -- Place unit button
    local placeUnitButton = PrimaryButton.create({
        name = "PlaceUnitButton",
        text = "Place Unit",
        size = UDim2.fromOffset(200, 48),
        backgroundColor = PLACE_UNIT_COLOR,
    })
    placeUnitButton.LayoutOrder = 2
    applyButtonConstraints(placeUnitButton, Vector2.new(168, 44), Vector2.new(240, 52), 20)
    placeUnitButton.Parent = controlsFrame

    -- Select unit button
    local selectButton = PrimaryButton.create({
        name = "SelectButton",
        text = "Select",
        size = SELECT_BUTTON_SIZE,
        backgroundColor = SELECT_BUTTON_COLOR,
    })
    selectButton.LayoutOrder = 3
    applyButtonConstraints(selectButton, Vector2.new(108, 36), Vector2.new(160, 44), 16)
    selectButton.Parent = controlsFrame

    return {
        frame = frame,
        mainControls = controlsFrame,
        placeUnitButton = placeUnitButton,
        selectButton = selectButton,
        behaviorContainer = behaviorContainer,
        behaviorButtons = {
            PEACEFUL = peacefulButton,
            DEFENSIVE = defensiveButton,
            AGGRESSIVE = aggressiveButton,
        },
        unitCard = nil,
    }
end

function module.setBehaviorSelected(screen: screen, behavior: Behavior?)
    for behaviorKey, button in screen.behaviorButtons do
        PrimaryButton.setSelected(button, behavior == behaviorKey)
    end
end

return module
