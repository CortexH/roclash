local module = {}

module.__index = module
module.contextName = "SnapshotBC"

function module.new()
	local self = setmetatable({}, module)

	self.snapshotUnits = {}

	return self
end

function module:addSnapshotUnit(
	id, cell, orientation
)
	self.snapshotUnits[id] = {cell = cell, orientation = orientation}
end

function module:getSnapshotUnit(id)
	return self.snapshotUnits[id]
end

function module:getAllSnapshotUnits()
	return self.snapshotUnits
end

return module
