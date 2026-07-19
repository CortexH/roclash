local module = {}

local brainService = require(script.Parent.Parent.Parent.Parent.Parent.Parent.application.service.npc.BrainService)
local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain

local brainPort = require(domain.ports.NpcBrainPort)
local apiPort = require(game.ServerStorage.Server.services.combatService.API.npcModule.NpcModuleAPI)

apiPort.manuallyCreateUnitBrain = function(unitId, context)
	local brain = brainService.createBrain()
	brainPort.saveBrain(unitId, brain, context)
end

return module
