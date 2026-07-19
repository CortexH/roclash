local module = {}

local structure = require(script.Parent.StructureEntity)
local npc = require(script.Parent.NpcEntity)

export type sendData = {
	["structures"] : {
		["entities"] : {structure.entity},
		["entitiesPositions"] : {structure.position}
	},
	["npcs"] : {
		["entities"] : {npc.entity},
		["entitiesPositions"] : {npc.position}
	}
}

return module
