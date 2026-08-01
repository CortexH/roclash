local module = {}

local unitSelectionScreen = require(script.Parent.Parent.screens.UnitSelectionScreen)
local selectUnitInput = require(script.Parent.Parent.Parent.input.SelectUnitInput)
local combatUIService = require(script.Parent.Parent.CombatUIService)

type Screen = unitSelectionScreen.screen

local view: Screen

function module.init(screen: Screen)
    view = screen
    
    view.selectButton.Activated:Connect(function()
        combatUIService.show("battleHud")
        selectUnitInput.beginSelect()
    end)
end

return module