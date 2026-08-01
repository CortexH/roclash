local unitBattleView = require(script.Parent.Parent.entity.UnitBattleView)
local selfBattleView = require(script.Parent.Parent.entity.SelfBattleView)
local unitVersionView = require(script.Parent.Parent.entity.UnitVersionView)

local module = {
	getUnitBattleView = function(selfId, targetId, context) : unitBattleView.UnitBattleView return {} end,
	getSelfBattleView = function(selfId, context) : selfBattleView.SelfBattleView return {} end,
	getUnitVersionView = function(unitId, context) : unitVersionView.UnitVersionView return {} end
}

return module
