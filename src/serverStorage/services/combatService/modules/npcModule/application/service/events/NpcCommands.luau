local module = {}

export type UnitAggroCommand = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommand",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	}
}

return module