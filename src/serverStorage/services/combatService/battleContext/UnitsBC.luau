local module = {}

module.__index = module

module.contextName = "UnitsBC"

function module.new()
	local self = setmetatable({}, module)
	
	self.activeUnits = {}
	self.reservedUnits = {}
	
	self.unitsInPositions = {}
	
	self.allUnits = {}
	
	return self
end

function module:addActiveUnit(unit)
	self.activeUnits[unit.uniqueId] = unit
	
	if not self.unitsInPositions[formatCell(unit.currentCell)] then
		self.unitsInPositions[formatCell(unit.currentCell)] = {}
	end
	
	if not self.allUnits[unit.uniqueId] then 
		self.allUnits[unit.uniqueId] = unit
	end
	
	table.insert(self.unitsInPositions[formatCell(unit.currentCell)], unit)
end

function module:getActiveUnitById(id)
	return self.activeUnits[id]
end

function module:getAllActiveUnits()
	return self.activeUnits
end

function module:getAllUnits()
	return self.allUnits
end

function module:getUnit(id)
	return self.allUnits[id]
end

-- BY CELL

function module:getActiveUnitByCell(cell : {x: number, y : number})
	return self.unitsInPositions[formatCell(cell)] or {}
end

function module:unitChangedPosition(previousCell, actualCell, unitId)

	local prevKey = formatCell(previousCell)
	local actualKey = formatCell(actualCell)

	local prevList = self.unitsInPositions[prevKey]
	if not prevList then
		return
	end

	local unitToMove = nil
	local indexToRemove = nil

	for i, v in ipairs(prevList) do
		if v:getId() == unitId then
			unitToMove = v
			indexToRemove = i
			break
		end
	end

	if not unitToMove then
		return
	end

	table.remove(prevList, indexToRemove)

	self.unitsInPositions[actualKey] = self.unitsInPositions[actualKey] or {}
	table.insert(self.unitsInPositions[actualKey], unitToMove)

	if #prevList == 0 then
		self.unitsInPositions[prevKey] = nil
	end
end

-- RESERVED --

function module:addReservedUnit(unit)
	self.reservedUnits[unit.uniqueId] = unit
	if not self.allUnits[unit.uniqueId] then 
		self.allUnits[unit.uniqueId] = unit
	end
end

function module:getAllReservedUnits()
	return self.reservedUnits
end

function module:getAllReservedUnitsByList()
	local list = {}
	
	for _, unit in pairs(self.reservedUnits) do
		table.insert(list, unit)
	end
	
	return list
end

function module:getReservedUnitById(unitId)
	return self.reservedUnits[unitId]
end

function module:promoteReservedUnitToActiveUnit(unitId)
	local unit = self.reservedUnits[unitId]
	self.reservedUnits[unitId] = nil
	self:addActiveUnit(unit)
end

function module:getAllPlacedAttackerUnits()
	local list = {}
	
	for _, unit in pairs(self.activeUnits) do
		if not unit.placed then continue end
		if not unit:isAttacker() then continue end
		table.insert(list, unit)
	end
	
	return list
end

function formatCell(cell)
	return tostring(cell.x) .. "," .. tostring(cell.y)
end

return module
