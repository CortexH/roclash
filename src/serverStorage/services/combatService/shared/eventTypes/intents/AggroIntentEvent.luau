local module = {}

export type AggroIntentRejectReason = "OUT_OF_RANGE" | "TARGET_DEAD"
									| "COOLDOWN_NOT_READY" | "INVALID_TARGET"
									| "INVALID_INPUT" | "SOURCE_VIEW_NOT_FOUND"
									| "INVALID_AGGRO_RANGE"

export type AggroPolicyType = "COMMAND" | "AUTO"

export type AggroIntent = {
	["delay"] : number,
	["eventType"] : "AggroIntent",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,
		["origin"] : {
            type : string,
            playerId : string | nil
        },
		["policy"] : AggroPolicyType
	},
	["isValid"] : boolean
}

export type AggroIntentRejected = {
	["delay"] : number,
	["eventType"] : "AggroIntentRejected",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,
		["reason"] : string,

		["origin"] : {
            type : string,
            playerId : string | nil
        },
		["reason"] : AggroIntentRejectReason
	},
	["isValid"] : boolean
}

export type AggroIntentAccepted = {
	["delay"] : number,
	["eventType"] : "AggroIntentAccepted",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,
	},
	["isValid"] : boolean
}

return module