local module = {}

local battleHudScreen = require(script.Parent.Parent.screens.BattleHudScreen)

local controllers = {
    require(script.Parent.battleHudSubControllers.SelectionController),
    require(script.Parent.battleHudSubControllers.PlaceUnitController),
    require(script.Parent.battleHudSubControllers.CardController)
}

type Behavior = battleHudScreen.Behavior

type Screen = battleHudScreen.screen

function module.init(screen: Screen)  
    for _, v in controllers do
        v.init(screen)
    end
end

return module
