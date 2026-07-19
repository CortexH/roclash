local module = {}

local domain = script.Parent.Parent
local unitEntity = require(domain.entity.UnitEntity)
local mathService = require(domain.domainService.MathService)

function module.getUnitsInAttackRange(source : unitEntity.unitEntity, allUnits : {unitEntity.unitEntity}, ct : number)
	if not source:getAttacker() then return {} end
	local range = source:getAttacker():getRange()
	if source:isDead() then return {} end
	
	local inRange = {}
	
	for _, unit in allUnits do
		if unit:isDead() then continue end
		if unit:getParty() == source:getParty() then continue end
		local unitPos = unit:getPosition():getCurrentPosition(ct)
		if unitPos:distanceTo(
				source:getPosition():getCurrentPosition(ct)
			) <= range then
			table.insert(inRange, unit)
		end
	end
	
	return inRange
end

function module.validateIfUnitIsInAttackRange(source : unitEntity.unitEntity, target : unitEntity.unitEntity, ct)
	if not source or not target then return false end
	if not source:getAttacker() then return false end
	if source:isDead() then return false end
	if target:isDead() then return false end
	
	local range = source:getAttacker():getRange()
	
	local inRange = false
	
	local unitPos = target:getPosition():getCurrentPosition(ct)
		
	local dist = unitPos:distanceTo(source:getPosition():getCurrentPosition(ct))
		
	if dist <= range then
		inRange = true
	end
	
	return inRange
	
end

return module
