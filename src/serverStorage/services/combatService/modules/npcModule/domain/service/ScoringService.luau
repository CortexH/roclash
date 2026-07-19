local module = {}

local domain = script.Parent.Parent

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local aggroScoringCalc = require(script.Parent.ScoringCalc.AggroScoringCalc)

function module.getAggroScore(selfId : string, targetId : string, context, additionalScore)
	
	local self = viewPort.getSelfBattleView(selfId, context)
	local unit = viewPort.getUnitBattleView(selfId, targetId, context)
		
	if not self or not unit then return 0 end
		
	if not additionalScore then additionalScore = 0 end
		
	return additionalScore + aggroScoringCalc.calculate(self, unit, context)
end

return module
