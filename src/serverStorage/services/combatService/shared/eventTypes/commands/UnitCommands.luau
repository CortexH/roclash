local module = {}

export type unitAggroCommand = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommand",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
		{
			["unitId"] : string,
			["targetId"] : string
		}
	}
}

return module