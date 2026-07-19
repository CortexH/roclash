local unitBattleView = require(script.Parent.Parent.entity.UnitBattleView)
local selfBattleView = require(script.Parent.Parent.entity.SelfBattleView)

local module = {
	getUnitBattleView = function(selfId, targetId, context) : unitBattleView.UnitBattleView return {} end,
	getSelfBattleView = function(selfId, context) : selfBattleView.SelfBattleView return {} end
}

return module
