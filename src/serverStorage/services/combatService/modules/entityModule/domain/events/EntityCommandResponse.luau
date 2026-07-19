local module = {}

module.commandResponseTypes = {
	"UnitPlacementCommandResponse"
}

export type unitPlacementCommandResponse = {
	["eventType"] : "UnitPlacementCommandResponse",
	["delay"] : number,
	["type"] : "COMMAND_RESPONSE",
	["data"] : {
		["commandResponseType"] : "FAIL" | "SUCCESS",
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

export type unitMoveCommandResponse = {
	["eventType"] : "UnitMoveCommandResponse",
	["delay"] : number,
	["type"] : "COMMAND_RESPONSE",
	["data"] : {
		["commandResponseType"] : "FAIL" | "SUCCESS",
		["fault"] : {
			["entityId"] : string,
			["reason"] : string
		}?,
		["success"] : {
			["entityId"] : string
		}
	}
}

return module
