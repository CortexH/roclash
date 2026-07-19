local module = {}

local entityUnit = require(script.Parent.Parent.entity.UnitEntity)

local positionVO = require(script.Parent.Parent.valueObjects.Position)
local mathService = require(script.Parent.MathService)

local movementDomainService = require(script.Parent.MovementDomainService)

function module.verifyNpcWalkingIntersection(
	targetUnit : entityUnit.unitEntity, 
	firstPosition : positionVO.position, 
	finalPosition : positionVO.position, 
	worldAttackerUnits : {entityUnit.unitEntity}
) : {[string] : {enterTime :number, leaveTime :number}}
		
	local npcTravelTime = mathService.getTravelTime(
		firstPosition, 
		finalPosition, 
		movementDomainService.getUnitWalkSpeed(targetUnit)
	)

	local intersectUnits = {}

	for _, attacker in ipairs(worldAttackerUnits) do
	
		local enterTime, leaveTime = mathService.getTimeInsideHitbox(
			firstPosition,
			finalPosition,
			attacker:getPosition():getCurrentPosition(),
			attacker:getAttacker():getRange(),
			npcTravelTime
		)
		
		if enterTime ~= nil then

			local intersectionData = {}

			if enterTime > 0 then
				intersectionData.enterTime = enterTime
			end

			if leaveTime < npcTravelTime then
				intersectionData.leaveTime = leaveTime
			end

			if next(intersectionData) ~= nil then
				intersectUnits[attacker:getId()] = intersectionData
			end
		end
	end
	
	return intersectUnits
end

function module.getTowerNewTarget(tower : entityUnit.unitEntity)
	
end

return module
