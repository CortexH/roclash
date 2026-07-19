local module = {}

local domain = script.Parent.Parent

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local scoringService = require(domain.service.ScoringService)

function module.getBestTarget(unitId, brain : typeof(brainPort.getNpcBrain()), context) : string
	
	local bestScore = -math.huge
	local bestTarget = nil
	
	for targetId, target in pairs(brain:getAggro():getCandidates()) do
		local score = scoringService.getAggroScore(unitId, targetId, context)
		
		if score > bestScore then
			bestScore = score
			bestTarget = targetId
		end
	end
	
	return bestTarget
end

return module
