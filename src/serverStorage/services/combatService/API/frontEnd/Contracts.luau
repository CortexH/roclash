local stateType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitStateDataType)
local definitionType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitDefinitionDataType)

local module = {}

export type loadDataContract = {
	["units"] : {
		[string] : {
			state : stateType.unitState,
			definition : definitionType.unitDefinition
		}
	},
	map : mapConfig
}

export type mapConfig = {
	cellSize : number,
	battleFieldFirstCornerPosition : {x : number, y : number},
	battleFieldLastCornerPosition : {x : number, y : number},
	mapId : number
}

return module
