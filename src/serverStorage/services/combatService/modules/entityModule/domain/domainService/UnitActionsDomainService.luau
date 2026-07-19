local module = {}

local entityUnit = require(script.Parent.Parent.entity.UnitEntity)

local positionVO = require(script.Parent.Parent.valueObjects.Position)
local mathService = require(script.Parent.MathService)

local movementDomainService = require(script.Parent.MovementDomainService)

export type verifyNpcWalkingIntersectionResponse = {
	[string] : {
		intersect : boolean,
		intersectBeginTime : number?,
		intersectEndTime : number?
	}
}

-- verifica intersecções entre o movimento de um npc e os atacantes
function module.verifyNpcWalkingIntersection(
	targetUnit : entityUnit.unitEntity, 
	firstPosition : positionVO.position, 
	finalPosition : positionVO.position, 
	worldAttackerUnits : {entityUnit.unitEntity}
) : typeof({["a"] = {enterTime = 0, leaveTime = 0}})

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
			attacker:getPosition(),
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

function module.verifyUnitInRangeOfAttackers(
	targetUnit : entityUnit.unitEntity,
	worldAttackerUnits : {entityUnit.unitEntity}
) : {string}
	
	local inRangeUnits = {}
	
	for _, attacker in ipairs(worldAttackerUnits) do
		if attacker:isInRange(targetUnit:getPosition()) then
			table.insert(inRangeUnits, attacker:getId())
		end
	end
	
	return inRangeUnits
end

function module.getUnitsInAggroRange(
	targetUnit : entityUnit.unitEntity,
	worldUnits : {entityUnit.unitEntity}
)
	if not targetUnit then return {} end
	if not worldUnits then return {} end
	
	if targetUnit.config.unitType ~= "NPC" then return {} end
	
	local inRangeUnits = {}

	for _, unit in ipairs(worldUnits) do
		if targetUnit:isInAggroRange(unit:getPosition():getCurrentPosition()) then
			table.insert(inRangeUnits, unit)
		end
	end
	
	return inRangeUnits
end

return module
