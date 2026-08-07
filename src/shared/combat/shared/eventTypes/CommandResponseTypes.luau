local module = {}

export type unitPlacementCommandResponse = {
	["eventType"] : "UnitPlacementCommandResponse",
	["delay"] : number,
	["data"] : {
		["commandResponseType"] : "REJECT" | "SUCCESS",
		["fault"] : string,
		["FAULT"] : {
			["entityId"] : string,
			["position"] : string,
			["behavior"] : string
		} | nil,
		["success"] : {
			["entityId"] : string,
			["position"] : {x : number, y : number},
			["behavior"] : string
		} | nil,
		["reason"] : string | nil,
		["eventData"] : {}
	}
}

export type unitAggroCommandResponse = {
	["eventType"] : "UnitAggroCommandResponse",
	["delay"] : number,
	["data"] : {
		["commandResponseType"] : "REJECT" | "SUCCESS",
		["success"] : {
			["entityId"] : string,
			["position"] : {x : number, y : number},
			["behavior"] : string
		} | nil,
		["reason"] : string | nil,
		["eventData"] : {}
	}
}

return module
