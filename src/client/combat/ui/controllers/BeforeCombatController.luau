local module = {}

local beforeCombatScreen = require(script.Parent.Parent.screens.BeforeCombatScreen)
local remotes = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)

function module.init(view : beforeCombatScreen.screen)
    view.startButton.Activated:Connect(activateStartButton)
end

function activateStartButton()
    remotes.runtime.StartBattle:FireServer()
end

return module