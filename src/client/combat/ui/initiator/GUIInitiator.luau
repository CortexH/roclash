local module = {}

local uiRoot = require(script.Parent.Parent.Parent.Parent.core.ui.UIRoot)
local uiService = require(script.Parent.Parent.CombatUIService)

local beforeCombatScreen = require(script.Parent.Parent.screens.BeforeCombatScreen)
local beforeCombatController = require(script.Parent.Parent.controllers.BeforeCombatController)
local battleHudScreen = require(script.Parent.Parent.screens.BattleHudScreen)
local battleHudController = require(script.Parent.Parent.controllers.BattleHudController)


function module.init()
    initBeforeCombatHUD()
    initBattleHud()

    uiService.show("beforeCombat")
end

function initBeforeCombatHUD()
    local screen = beforeCombatScreen.build(uiRoot.getScreens())
    uiService.register("beforeCombat", screen.frame)
    beforeCombatController.init(screen)
end

function initBattleHud()
    local screen = battleHudScreen.build(uiRoot.getScreens())
    uiService.register("battleHud", screen.frame)
    battleHudController.init(screen)
end

return module