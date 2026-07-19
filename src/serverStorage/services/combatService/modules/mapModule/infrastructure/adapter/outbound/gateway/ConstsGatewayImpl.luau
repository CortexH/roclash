local module = {}

local constsPorts = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.ConstsDataPort)
-- TODO: adaptar para pegar as consts dos dados retornados em 'playerDatastore'
local buildModeConsts = require(game.ReplicatedStorage.Shared.constants.BuildModeConsts)

constsPorts.getCellSize = function()
	return buildModeConsts.cellSize
end

constsPorts.getFirstCornerPosition = function() : (number, number)
	local field : Part = buildModeConsts.battleFieldPart
	local pos = field.Position - Vector3.new(field.Size.X / 2, 0, field.Size.Z / 2)
	
	return pos.X, pos.Z
end

constsPorts.getLastCornerPosition = function() : (number, number)
	local field : Part = buildModeConsts.battleFieldPart
	local pos = field.Position + Vector3.new(field.Size.X / 2, 0, field.Size.Z / 2)

	return pos.X, pos.Z
end

return module
