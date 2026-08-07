local module = {}

export type SpawnIntent = {
	["delay"] : number,
	["eventType"] : "SpawnIntent",
	["type"] : "EVENT",
	["data"] : {
		["entityId"] : string,
		["position"] : {x : number, y : number},
		["behavior"] : string,
		["origin"] : {
			type : string,
			playerId : string | nil
		}?
	},
	["isValid"] : boolean
}

export type SpawnIntentAccepted = {
	["delay"] : number,
	["eventType"] : "SpawnIntentAccepted",
	["type"] : "EVENT",
	["data"] : {
		["entityId"] : string,
		["position"] : {x : number, y : number},
		["behavior"] : string,
		["origin"] : {
			type : string,
			playerId : string | nil
		}?
	},
	["isValid"] : boolean
}

export type SpawnIntentRejected = {
	["delay"] : number,
	["eventType"] : "SpawnIntentRejected",
	["type"] : "EVENT",
	["data"] : {
		["entityId"] : string,
		["position"] : {x : number, y : number}?,
		["behavior"] : string?,
		["reason"] : string,
		["origin"] : {
			type : string,
			playerId : string | nil
		}?
	},
	["isValid"] : boolean
}

return module
