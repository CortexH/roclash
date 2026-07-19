local npcBrain = require(script.Parent.Parent.entity.Brain)
local module = {
	getNpcBrain = function(unitId, context) : npcBrain.Brain return {} end,
	getAllNpcBrains = function(context) : {npcBrain.Brain} return {} end,
	getAllNpcsBrainsWithId = function(context) : {[string] : npcBrain.Brain} end, 
	saveBrain = function(unitId, brain, context) end
}

return module
