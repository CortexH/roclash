local module = {}

module.getCommandTypes = {
	"UnitPlacementCommand"
}

export type unitPlacementCommand = {
	["eventType"] : "UnitPlacementCommand",
	["delay"] : number,
	["requesterId"] : string,
	["type"] : "COMMAND",
	["data"] : {
		{
			["behavior"] : string,
			["position"] : {x : number, y : number},
			["entityId"] : string
		}
	}
}

export type unitTargetCommand = {
	["delay"] : number,
	["eventType"] : "UnitTargetCommand",
	["type"] : "COMMAND",
	["rquesterId"] : string,
	["data"] : {
		{
			["unitId"] : string,
			["targetId"] : string
		}
	}
}

export type unitMoveCommand = {
	["delay"] : number,
	["eventType"] : "UnitMoveCommand",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
		{
			["unitId"] : string,
			["position"] : {x : number, y : number}
		}
	}
}

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
