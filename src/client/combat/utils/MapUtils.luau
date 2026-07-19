local module = {}

local plMapUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.PlayerMapUtils)
local consts = require(script.Parent.Parent.consts.MapConsts)

function module.getCellByPosition(position : {x : number, y : number}) : {x : number, y : number}
	return plMapUtils.getCellByPosition(position, consts)
end

function module.getPositionByCell(cell : {x : number, y : number}) : Vector2
	return plMapUtils.getPositionByCell(cell, consts)
end

function module.getMapBaseElevation()
	return plMapUtils.getMapBaseElevation()
end

return module
