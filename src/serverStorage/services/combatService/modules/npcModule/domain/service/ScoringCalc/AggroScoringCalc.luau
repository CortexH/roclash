local module = {}

local domain = script.Parent.Parent.Parent

local selfBattleViewType = require(domain.entity.SelfBattleView)
local unitBattleViewType = require(domain.entity.UnitBattleView)


function module.calculate(selfView, unitView, context)
	local score = 0

	score += getAggroDistanceScore(selfView, unitView)
	--score += getHealthScore(unitView)
	--score += getObservedStatusScore(selfView, unitView)
	--score += unitView.priority * 5
	--score -= unitView.threatLevel * 3
	
	return score
end

function getAggroDistanceScore(self, unit)
	local dist = unit.distanceToSelf
	local range = self.aggroRange

	local normalized = dist / range

	if normalized <= 1 then
		return (1 - normalized)^2 * 10
	else
		return 1 / (normalized^2) * 2 -- influência fraca fora do range
	end
end


function getHealthScore(unit)
	if unit.health <= 0 then
		return 0
	end

	local healthPercent = unit.health / unit.maxHealth
	return (1 - healthPercent) * 10
end


function getObservedStatusScore(self, unit)

	local confidence = unit.observationConfidence or 0
	if confidence == 0 then return 0 end

	if not unit.observedAttackDamage or not unit.observedAttackSpeed then
		return 0
	end

	local enemyDPS = unit.observedAttackDamage * unit.observedAttackSpeed
	local myDPS = self.damage * self.attackSpeed

	if enemyDPS <= 0 or myDPS <= 0 then
		return 0
	end

	local timeToKillEnemy = unit.health / myDPS
	local timeToKillMe = self.health / enemyDPS

	local duelScore = timeToKillMe / (timeToKillEnemy + timeToKillMe)

	return duelScore * confidence * 15
end

return module