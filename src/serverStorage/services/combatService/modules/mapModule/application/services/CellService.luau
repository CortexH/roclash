local module = {}

function module.isCellReserved(cell, context)
	local reserved = context["MapStateBC"]["reservedCells"]
	local key = cell.x .. "," .. cell.y
	if reserved[key] and reserved[key] == true then
		return true
	end
	
	return false
end

function module.reserveCell(cell, context)
	local reserved = context["MapStateBC"]["reservedCells"]
	local key = cell.x .. "," .. cell.y
	reserved[key] = true
end

function module.unreserveCell(cell, context)
	local reserved = context["MapStateBC"]["reservedCells"]
	local key = cell.x .. "," .. cell.y
	reserved[key] = nil
end

return module
