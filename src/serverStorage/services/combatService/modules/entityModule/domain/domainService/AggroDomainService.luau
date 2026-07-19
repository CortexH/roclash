local module = {}

local domain = script.Parent.Parent
local unitEntity = require(domain.entity.UnitEntity)
local mathService = require(domain.domainService.MathService)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

local facingTypes = {
	["WEST"] = 0,
	["NORTH"] = 1,
	["EAST"] = 2,
	["SOUTH"] = 3
}

--TODO: em algum momento vai ser possível da unit aggrar em entidades se movendo. não esqueça de cuidar disso.
-- outro ponto: eu fiz isso com as coxa, verifica depois pra ver se tá tudo ok (tá funcionando)
function module.getNearestUnitInAggroPath(
	aggroUnit : unitEntity.unitEntity, 
	target : unitEntity.unitEntity, 
	context)
	
	if aggroUnit:getNpcConfig():getBehavior() == "PEACEFUL" then
		return false
	end

	local allCells = mathService.getCellsFromTraverseGrid(
		aggroUnit:getPosition():getCurrentPosition(),
		target:getPosition():getCurrentPosition(),
		mapPort.getCellSize()
	)

	local unitsBC = context["UnitsBC"]
	local selectedUnit = nil

	for _, v in ipairs(allCells) do

		local unitsInCell = unitsBC:getActiveUnitByCell(v.cell)
		if not unitsInCell then
			continue
		end

		local logicalUnits = {}

		for _, unit in ipairs(unitsInCell) do
			if unit:getId() ~= aggroUnit:getId()
				and unit:getParty() ~= aggroUnit:getParty()
				and not unit:isDead()
				and unit.config.blockCellType == "BORDER" then
				table.insert(logicalUnits, unit)
			end
		end

		for _, unit in ipairs(unitsInCell) do
			if unit:getId() ~= aggroUnit:getId()
				and unit:getParty() ~= aggroUnit:getParty()
				and not unit:isDead()
				and unit.config.blockCellType == "ONLY_CENTER" then

				table.insert(logicalUnits, unit)
			end
		end

		for _, unit in ipairs(logicalUnits) do

			if unit.config.blockCellType == "BORDER" then

				if not selectedUnit and facingTypes[v.enteredFrom] == unit.currentFacing then
					selectedUnit = unit
					break
				end

				if not selectedUnit and facingTypes[v.leftFrom] == unit.currentFacing then
					selectedUnit = unit
					break
				end
			end

			if not selectedUnit and (
				unit.config.blockCellType == "ONLY_CENTER" or
					unit.config.blockCellType == "ENTIRE_CELL"
				) then
				selectedUnit = unit
				break
			end
		end

		if selectedUnit then
			break
		end
	end

	if not selectedUnit then
		selectedUnit = target
	end

	return selectedUnit
end

function module.getAggroPosition(
	aggroingUnit : unitEntity.unitEntity,
	target : unitEntity.unitEntity
)
	
	local hitDistance = (aggroingUnit:getAttacker():getRange() - (mapPort.getCellSize() / 1.5))
		
	local hitPosition = mathService.vectorUntilRange(
		aggroingUnit:getPosition():getCurrentPosition(), 
		target:getPosition():getCurrentPosition(), 
		hitDistance
	)
	
	local r = mapPort.getCellFromPosition(hitPosition)
	return r
end

function module.getNextAggroTarget(source : unitEntity.unitEntity, context)
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	
	local possibleTargets = {}

	for _, unit : unitEntity.unitEntity in unitsBC:getAllActiveUnits() do
		if source:getParty() == unit:getParty() then continue end
		if unit:isDead() then continue end
		
		if source:getPosition():getCurrentPosition(ct)
			:distanceTo(unit:getPosition():getCurrentPosition(ct)) > source:getNpcConfig()
			:getAggroRange() then continue end
		
		table.insert(possibleTargets, unit)
	end
	
	if #possibleTargets < 1 then return nil end
	
	local nearest = getNearestUnit(possibleTargets, source, context)
	
	return module.getNearestUnitInAggroPath(source, nearest, context)
end

function getNearestUnit(inRangeUnits, spawnedUnit, context)
	local smallest = math.huge
	local nearest = nil

	for _, unit in ipairs(inRangeUnits) do
		local dist = unit:getPosition():getCurrentPosition()
			:distanceSquared(spawnedUnit:getPosition():getCurrentPosition())

		if dist < smallest then
			smallest = dist
			nearest = unit
		end

		if dist == smallest then
			nearest = unit
		end
	end

	return nearest
end

return module
