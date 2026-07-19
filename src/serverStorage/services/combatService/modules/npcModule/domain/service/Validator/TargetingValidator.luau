local module = {}
local entities = script.Parent.Parent.Parent.entity

local unitView = require(entities.UnitBattleView)
local selfView = require(entities.SelfBattleView)

local brainPort = require(script.Parent.Parent.Parent.ports.NpcBrainPort)

local viewPort = require(script.Parent.Parent.Parent.ports.BattleViewPort)

function nearestPriority(self : selfView.SelfBattleView, ids, context)

	local sortedIds = table.clone(ids)

	local allUnits = {}

	for _, id in ids do
		allUnits[id] = viewPort.getUnitBattleView(self.id, id, context)
	end

	table.sort(sortedIds, function(a, b)
		return allUnits[a].distanceToSelf < allUnits[b].distanceToSelf
	end)

	return sortedIds
end

-- TODO: adicionar stickiness priority, por exemplo:
-- alvo entra primeiro: ganha alguns pontos de prioridade, e outro só é 'focado' caso tenha prioridade maior.
local priorityOrganizer = {
	["NEAREST"] = nearestPriority
}

function module.getBestTargets(unit : selfView.SelfBattleView, unitsIds : {string}, context)
	local organizedTargetsIds = priorityOrganizer[unit.targetingPriority](unit, unitsIds, context)
		
	local newTargets = {}
	
	
	for i = 1, math.min(unit.maxTargets, #organizedTargetsIds) do
		newTargets[i] = organizedTargetsIds[i]
	end
	
	return newTargets
end

return module
