local module = {}

local entities = script.Parent.Parent.entity

local unitView = require(entities.UnitBattleView)
local selfView = require(entities.SelfBattleView)

local battleViewPort = require(script.Parent.Parent.ports.BattleViewPort)

local brainPort = require(script.Parent.Parent.ports.NpcBrainPort)

local targetingValidator = require(script.Parent.Validator.TargetingValidator)

function module.getNpcNextTarget(self : selfView.SelfBattleView, context)
end

function module.getTowerTargetDelta(self : selfView.SelfBattleView, context) : {
	next : {string}, added : {string}, removed : {string}, maintained : {string}
	}
	local brain = brainPort.getNpcBrain(self.id, context)
	
	local targeting = brain:getTargeting()

	local possibleTargets = targeting:getPossibleTargetsList()
	local currentTargets = targeting:getActiveTargetsList() or {}

	if #possibleTargets == 0 then
		return {
			next = {},
			added = {},
			removed = currentTargets,
			maintained = {}
		}
	end

	local nextTargets = targetingValidator.getBestTargets(self, possibleTargets, context)

	local currentSet = {}
	local nextSet = {}

	for _, id in currentTargets do
		currentSet[id] = true
	end

	for _, id in nextTargets do
		nextSet[id] = true
	end

	local delta = {
		next = nextTargets,
		added = {},
		removed = {},
		maintained = {}
	}

	for _, id in nextTargets do
		if currentSet[id] then
			table.insert(delta.maintained, id)
		else
			table.insert(delta.added, id)
		end
	end

	for _, id in currentTargets do
		if not nextSet[id] then
			table.insert(delta.removed, id)
		end
	end

	return delta
end

function module.getNpcsTargetingNpc(target : selfView.SelfBattleView, context) : {unitView.UnitBattleView}
	
end

function module.getPossibleTargetsUnitIsIn(unit : selfView.SelfBattleView, context) : {unitView.UnitBattleView}
	
end

return module
